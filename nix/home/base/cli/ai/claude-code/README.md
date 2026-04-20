# claude-code

## MCP Servers

```sh
claude mcp add-json "serena" '{
      "type": "stdio",
      "command": "serena",
      "args": [
        "start-mcp-server",
        "--context",
        "claude-code",
        "--project-from-cwd",
        "--enable-web-dashboard",
        "False",
        "--enable-gui-log-window",
        "False"
      ],
      "env": {
        "SERENA_HOME": "${PWD}/.serena"
      }
    }' --scope user
```
