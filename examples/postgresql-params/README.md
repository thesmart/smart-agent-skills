# PostgreSQL Connection Parameter Resolution

This document provides a high-level overview of how PostgreSQL's libpq library resolves connection
parameters and establishes a database connection.

## Process Diagram

```mermaid
flowchart TB
    subgraph init["1. Connection Request"]
        start([Application calls PQconnectdb/PQconnectdbParams])
        parse{Connection string<br/>format?}
        kv[Parse keyword=value pairs]
        uri[Parse URI components<br/>postgresql://user:pass@host:port/db?params]
        expand{dbname contains<br/>= or URI prefix?}
        expandDb[Expand dbname as<br/>connection string]
    end

    subgraph service["2. Service File Lookup"]
        svcCheck{service parameter<br/>specified?}
        svcEnv{PGSERVICE<br/>env var set?}
        svcFile[Read service file:<br/>~/.pg_service.conf or<br/>PGSERVICEFILE location]
        svcSys[Check system file:<br/>PGSYSCONFDIR/pg_service.conf]
        svcParse[Parse INI section<br/>matching service name]
        svcMerge[Merge service params<br/>into connection options]
    end

    subgraph env["3. Environment Variable Defaults"]
        envCheck[Check environment variables<br/>for unset parameters]
        envHost[PGHOST -> host]
        envPort[PGPORT -> port]
        envDb[PGDATABASE -> dbname]
        envUser[PGUSER -> user]
        envPass[PGPASSWORD -> password]
        envSSL[PGSSLMODE, PGSSLCERT,<br/>PGSSLKEY, PGSSLROOTCERT...]
        envOther[PGOPTIONS, PGAPPNAME,<br/>PGCONNECT_TIMEOUT...]
    end

    subgraph defaults["4. Built-in Defaults"]
        defApply[Apply built-in defaults<br/>for remaining unset params]
        defHost[host: /tmp Unix or localhost Win]
        defPort[port: 5432]
        defDb[dbname: username]
        defSSL[sslmode: prefer]
    end

    subgraph password["5. Password Resolution"]
        passCheck{Password<br/>specified?}
        passFile[Read password file:<br/>~/.pgpass or PGPASSFILE<br/>or passfile param]
        passMatch[Match first line:<br/>hostname:port:database:username:password]
        passWild[Wildcards: * matches any value]
        passFound{Match<br/>found?}
        passUse[Use matched password]
        passNone[No password - may prompt<br/>or fail auth]
    end

    subgraph multihost["6. Multi-Host Processing"]
        hostList{Multiple hosts<br/>specified?}
        hostParse[Parse comma-separated<br/>host1,host2,host3]
        portMap[Map ports to hosts<br/>single port applies to all]
        loadBal{load_balance_hosts<br/>= random?}
        shuffle[Randomize host order]
        hostQueue[Create ordered host queue]
    end

    subgraph connect["7. Connection Attempt per Host"]
        nextHost[Select next host<br/>from queue]
        resolve[Resolve hostname<br/>to IP addresses]
        nextAddr[Try next address]
        socket[Create TCP socket]
        timeout{connect_timeout<br/>reached?}
        tcpConnect[TCP connect to<br/>host:port]
        tcpOk{TCP connection<br/>successful?}
    end

    subgraph ssl["8. SSL/TLS Negotiation"]
        sslMode{sslmode?}
        sslDisable[Skip SSL]
        sslAllow[Try non-SSL first]
        sslPrefer[Try SSL first,<br/>fall back to non-SSL]
        sslRequire[Require SSL]
        sslVerifyCA[Require SSL +<br/>verify CA chain]
        sslVerifyFull[Require SSL +<br/>verify CA + hostname]
        sslNeg{sslnegotiation?}
        sslPg[PostgreSQL protocol:<br/>send SSLRequest]
        sslDirect[Direct TLS handshake]
        sslResp{Server supports<br/>SSL?}
        sslHandshake[TLS handshake]
        sslCert[Load client cert:<br/>~/.postgresql/postgresql.crt]
        sslKey[Load private key:<br/>~/.postgresql/postgresql.key]
        sslKeyPass{Key encrypted?}
        sslPassPrompt[Get passphrase via<br/>sslpassword or prompt]
        sslRoot[Load CA cert:<br/>~/.postgresql/root.crt or system]
        sslVerify{Certificate<br/>valid?}
        sslHostCheck{Hostname<br/>matches cert?}
    end

    subgraph auth["9. Authentication"]
        startup[Send StartupMessage<br/>with parameters]
        authReq{Authentication<br/>method?}
        authNone[Trust - no auth needed]
        authPass[Password auth]
        authMD5[MD5 challenge-response]
        authSCRAM[SCRAM-SHA-256]
        authGSS[GSSAPI/Kerberos]
        authSSPI[SSPI Windows auth]
        authOAuth[OAuth 2.0 Device Flow]
        authCert[Certificate auth]

        oauthFlow[Display verification URL<br/>and user code]
        oauthWait[Wait for user to<br/>authorize in browser]
        oauthToken[Retrieve bearer token]

        reqAuth{require_auth<br/>matches?}
        authSend[Send credentials]
        authOk{Authentication<br/>successful?}
    end

    subgraph session["10. Session Setup"]
        paramStatus[Receive ParameterStatus<br/>messages]
        backendKey[Receive BackendKeyData<br/>for cancel requests]
        readyQuery[Receive ReadyForQuery]
        sessionAttr{target_session_attrs?}
        checkRW[Query: SHOW transaction_read_only]
        checkStandby[Query: SELECT pg_is_in_recovery]
        attrMatch{Session<br/>matches?}
        connected([Connection Established])
    end

    subgraph errors["Error Handling"]
        connFail[Connection failed]
        moreAddr{More addresses<br/>for host?}
        moreHost{More hosts<br/>in queue?}
        allFailed([Connection Failed:<br/>return error])
    end

    %% Flow connections
    start --> parse
    parse -->|keyword=value| kv
    parse -->|URI| uri
    kv --> expand
    uri --> expand
    expand -->|yes| expandDb --> svcCheck
    expand -->|no| svcCheck

    svcCheck -->|yes| svcFile
    svcCheck -->|no| svcEnv
    svcEnv -->|yes| svcFile
    svcEnv -->|no| envCheck
    svcFile --> svcSys
    svcSys --> svcParse
    svcParse --> svcMerge
    svcMerge --> envCheck

    envCheck --> envHost & envPort & envDb & envUser
    envHost & envPort & envDb & envUser --> envPass
    envPass --> envSSL
    envSSL --> envOther
    envOther --> defApply

    defApply --> defHost & defPort & defDb & defSSL
    defHost & defPort & defDb & defSSL --> passCheck

    passCheck -->|yes| hostList
    passCheck -->|no| passFile
    passFile --> passMatch
    passMatch --> passWild
    passWild --> passFound
    passFound -->|yes| passUse --> hostList
    passFound -->|no| passNone --> hostList

    hostList -->|yes| hostParse
    hostList -->|no| hostQueue
    hostParse --> portMap
    portMap --> loadBal
    loadBal -->|yes| shuffle --> hostQueue
    loadBal -->|no| hostQueue

    hostQueue --> nextHost
    nextHost --> resolve
    resolve --> nextAddr
    nextAddr --> socket
    socket --> tcpConnect
    tcpConnect --> timeout
    timeout -->|yes| connFail
    timeout -->|no| tcpOk
    tcpOk -->|no| connFail
    tcpOk -->|yes| sslMode

    sslMode -->|disable| startup
    sslMode -->|allow| sslAllow --> startup
    sslMode -->|prefer| sslPrefer --> sslNeg
    sslMode -->|require| sslRequire --> sslNeg
    sslMode -->|verify-ca| sslVerifyCA --> sslNeg
    sslMode -->|verify-full| sslVerifyFull --> sslNeg

    sslNeg -->|postgres| sslPg --> sslResp
    sslNeg -->|direct| sslDirect --> sslHandshake
    sslResp -->|yes| sslHandshake
    sslResp -->|no, prefer| startup
    sslResp -->|no, require+| connFail

    sslHandshake --> sslCert
    sslCert --> sslKey
    sslKey --> sslKeyPass
    sslKeyPass -->|yes| sslPassPrompt --> sslRoot
    sslKeyPass -->|no| sslRoot
    sslRoot --> sslVerify
    sslVerify -->|no, verify-ca+| connFail
    sslVerify -->|yes| sslHostCheck
    sslVerify -->|no, require or less| startup
    sslHostCheck -->|no, verify-full| connFail
    sslHostCheck -->|yes or not verify-full| startup

    startup --> authReq
    authReq -->|trust| authNone --> paramStatus
    authReq -->|password| authPass --> reqAuth
    authReq -->|md5| authMD5 --> reqAuth
    authReq -->|scram-sha-256| authSCRAM --> reqAuth
    authReq -->|gss| authGSS --> reqAuth
    authReq -->|sspi| authSSPI --> reqAuth
    authReq -->|oauth| authOAuth --> oauthFlow
    authReq -->|cert| authCert --> reqAuth

    oauthFlow --> oauthWait
    oauthWait --> oauthToken
    oauthToken --> reqAuth

    reqAuth -->|no match| connFail
    reqAuth -->|match| authSend
    authSend --> authOk
    authOk -->|no| connFail
    authOk -->|yes| paramStatus

    paramStatus --> backendKey
    backendKey --> readyQuery
    readyQuery --> sessionAttr
    sessionAttr -->|any| connected
    sessionAttr -->|read-write| checkRW --> attrMatch
    sessionAttr -->|read-only/standby| checkStandby --> attrMatch
    sessionAttr -->|primary| checkStandby --> attrMatch
    sessionAttr -->|prefer-standby| checkStandby --> attrMatch
    attrMatch -->|yes| connected
    attrMatch -->|no| connFail

    connFail --> moreAddr
    moreAddr -->|yes| nextAddr
    moreAddr -->|no| moreHost
    moreHost -->|yes| nextHost
    moreHost -->|no| allFailed

    %% Styling
    classDef startEnd fill:#e1f5fe,stroke:#01579b
    classDef process fill:#fff3e0,stroke:#e65100
    classDef decision fill:#fce4ec,stroke:#880e4f
    classDef security fill:#e8f5e9,stroke:#1b5e20
    classDef error fill:#ffebee,stroke:#b71c1c

    class start,connected,allFailed startEnd
    class kv,uri,expandDb,svcFile,svcSys,svcParse,svcMerge,envCheck,envHost,envPort,envDb,envUser,envPass,envSSL,envOther,defApply,defHost,defPort,defDb,defSSL,passFile,passMatch,passWild,passUse,passNone,hostParse,portMap,shuffle,hostQueue,nextHost,resolve,nextAddr,socket,tcpConnect,startup,paramStatus,backendKey,readyQuery,checkRW,checkStandby process
    class parse,expand,svcCheck,svcEnv,passCheck,passFound,hostList,loadBal,timeout,tcpOk,sslMode,sslNeg,sslResp,sslKeyPass,sslVerify,sslHostCheck,authReq,reqAuth,authOk,sessionAttr,attrMatch,moreAddr,moreHost decision
    class sslHandshake,sslCert,sslKey,sslPassPrompt,sslRoot,authNone,authPass,authMD5,authSCRAM,authGSS,authSSPI,authOAuth,authCert,authSend,oauthFlow,oauthWait,oauthToken security
    class connFail,sslDisable,sslAllow,sslPrefer,sslRequire,sslVerifyCA,sslVerifyFull,sslPg,sslDirect error
```

---

## Phase Overview

### 1. Connection Request

The connection process begins when an application calls a libpq connection function such as
`PQconnectdb()` or `PQconnectdbParams()`. The provided connection string is parsed according to its
format:

- **Keyword/Value Format**: `host=localhost port=5432 dbname=mydb`
- **URI Format**: `postgresql://user:password@host:port/database?options`

If the `dbname` parameter contains an `=` sign or a URI prefix (`postgresql://`), it is expanded as
a nested connection string, allowing connection strings to be passed through the database name
field.

### 2. Service File Lookup

Service files provide named connection profiles that bundle multiple parameters under a single
service name. When a `service` parameter is specified (or `PGSERVICE` environment variable is set),
libpq searches for the service definition in:

| Location                        | Description                              |
| ------------------------------- | ---------------------------------------- |
| `~/.pg_service.conf`            | Per-user service file (checked first)    |
| `PGSERVICEFILE`                 | Custom location via environment variable |
| `$PGSYSCONFDIR/pg_service.conf` | System-wide service file                 |

Service files use INI format:

```ini
[mydb]
host=db.example.com
port=5432
dbname=production
user=appuser
```

Parameters from the matching service section are merged into the connection options, but can be
overridden by explicitly specified parameters.

### 3. Environment Variable Defaults

For any parameters not yet set, libpq checks corresponding environment variables:

| Environment Variable | Parameter          | Description                           |
| -------------------- | ------------------ | ------------------------------------- |
| `PGHOST`             | `host`             | Database server hostname              |
| `PGHOSTADDR`         | `hostaddr`         | Server IP address (bypasses DNS)      |
| `PGPORT`             | `port`             | Server port number                    |
| `PGDATABASE`         | `dbname`           | Database name                         |
| `PGUSER`             | `user`             | Username                              |
| `PGPASSWORD`         | `password`         | Password (insecure; prefer `.pgpass`) |
| `PGSSLMODE`          | `sslmode`          | SSL connection mode                   |
| `PGSSLCERT`          | `sslcert`          | Client certificate path               |
| `PGSSLKEY`           | `sslkey`           | Client private key path               |
| `PGSSLROOTCERT`      | `sslrootcert`      | Root CA certificate path              |
| `PGOPTIONS`          | `options`          | Additional server options             |
| `PGAPPNAME`          | `application_name` | Application identifier                |
| `PGCONNECT_TIMEOUT`  | `connect_timeout`  | Connection timeout (seconds)          |

### 4. Built-in Defaults

Any parameters still unset receive built-in default values:

| Parameter | Default Value                          |
| --------- | -------------------------------------- |
| `host`    | `/tmp` (Unix) or `localhost` (Windows) |
| `port`    | `5432`                                 |
| `dbname`  | Same as `user`                         |
| `user`    | Operating system username              |
| `sslmode` | `prefer`                               |

### 5. Password Resolution

If no password has been specified through any of the above methods, libpq consults the password
file:

| Platform   | Default Location                                          |
| ---------- | --------------------------------------------------------- |
| Unix/Linux | `~/.pgpass`                                               |
| Windows    | `%APPDATA%\postgresql\pgpass.conf`                        |
| Custom     | `PGPASSFILE` environment variable or `passfile` parameter |

The password file contains lines in the format:

```
hostname:port:database:username:password
```

- Fields support `*` as a wildcard matching any value
- The first matching line provides the password
- Colons and backslashes in values must be escaped with `\`
- On Unix, the file must have `0600` permissions or it will be ignored

### 6. Multi-Host Processing

PostgreSQL supports connecting to multiple hosts for failover scenarios. Hosts can be specified as
comma-separated lists:

```
host=primary.example.com,standby1.example.com,standby2.example.com
port=5432,5432,5433
```

Or in URI format:

```
postgresql://primary:5432,standby1:5432,standby2:5433/mydb
```

When `load_balance_hosts=random` is set, the host order is randomized for load distribution.
Otherwise, hosts are tried in the order specified until a successful connection is established.

### 7. Connection Attempt

For each host in the queue, libpq:

1. Resolves the hostname to one or more IP addresses
2. Attempts to connect to each address in order
3. Creates a TCP socket and initiates the connection
4. Respects the `connect_timeout` parameter per host

If a connection attempt fails, the next address (or next host) is tried. Only after all hosts and
addresses are exhausted does the overall connection fail.

### 8. SSL/TLS Negotiation

SSL behavior is controlled by the `sslmode` parameter:

| Mode          | Encryption   | Server Verification | Hostname Check |
| ------------- | ------------ | ------------------- | -------------- |
| `disable`     | No           | No                  | No             |
| `allow`       | If required  | No                  | No             |
| `prefer`      | If available | No                  | No             |
| `require`     | Yes          | No                  | No             |
| `verify-ca`   | Yes          | Yes                 | No             |
| `verify-full` | Yes          | Yes                 | Yes            |

For modes requiring SSL, libpq:

1. Negotiates SSL with the server (PostgreSQL protocol or direct TLS)
2. Loads the client certificate from `~/.postgresql/postgresql.crt`
3. Loads the private key from `~/.postgresql/postgresql.key`
4. Prompts for key passphrase if encrypted (via `sslpassword` or interactive)
5. Loads the root CA certificate for verification modes
6. Validates the server certificate chain and hostname as required

### 9. Authentication

After the connection is established (with or without SSL), libpq sends a startup message and the
server requests authentication. Supported methods include:

| Method          | Description                         |
| --------------- | ----------------------------------- |
| `trust`         | No authentication required          |
| `password`      | Cleartext password                  |
| `md5`           | MD5-hashed password challenge       |
| `scram-sha-256` | SCRAM-SHA-256 (recommended)         |
| `gss`           | GSSAPI/Kerberos                     |
| `sspi`          | Windows SSPI                        |
| `cert`          | SSL client certificate              |
| `oauth`         | OAuth 2.0 Device Authorization Flow |

The `require_auth` parameter can restrict which authentication methods the client accepts, providing
defense against downgrade attacks.

For OAuth authentication, libpq displays a verification URL and user code, waits for the user to
authorize in a browser, then retrieves the bearer token automatically.

### 10. Session Setup

After successful authentication, the server sends:

1. **ParameterStatus** messages with server configuration
2. **BackendKeyData** for query cancellation
3. **ReadyForQuery** indicating the connection is ready

If `target_session_attrs` is specified, libpq verifies the session type:

| Value            | Requirement                    |
| ---------------- | ------------------------------ |
| `any`            | Accept any server              |
| `read-write`     | Server must allow writes       |
| `read-only`      | Server must be read-only       |
| `primary`        | Server must be the primary     |
| `standby`        | Server must be a standby       |
| `prefer-standby` | Prefer standby, accept primary |

If the session doesn't match the requirements, the connection is closed and the next host is tried.

---

## Parameter Priority Summary

Parameters are resolved in this order, with later sources overriding earlier ones:

1. **Built-in defaults** (lowest priority)
2. **Environment variables**
3. **Service file settings**
4. **Connection string parameters** (highest priority)

This layered approach allows flexible configuration while ensuring explicit parameters always take
precedence.

---

## References

- [PostgreSQL 18: Database Connection Control Functions](https://www.postgresql.org/docs/18/libpq-connect.html)
- [PostgreSQL 18: Environment Variables](https://www.postgresql.org/docs/18/libpq-envars.html)
- [PostgreSQL 18: The Password File](https://www.postgresql.org/docs/18/libpq-pgpass.html)
- [PostgreSQL 18: The Connection Service File](https://www.postgresql.org/docs/18/libpq-pgservice.html)
- [PostgreSQL 18: SSL Support](https://www.postgresql.org/docs/18/libpq-ssl.html)
- [PostgreSQL 18: OAuth Support](https://www.postgresql.org/docs/18/libpq-oauth.html)
