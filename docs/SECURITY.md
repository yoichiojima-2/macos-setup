# Security Best Practices for API Keys and Secrets

## Quick Start

1. **Set up secrets management:**
   ```bash
   source ~/Developer/repo/macos-setup/scripts/secrets.sh
   secret_setup  # Interactive setup
   ```

2. **For MCP configuration, see the vibe repository**

## Recommended Approach: macOS Keychain

This setup uses macOS Keychain for secure secret storage:

### Store secrets:
```bash
secret_set OPENAI_API_KEY "your-api-key-here"
secret_set GITHUB_TOKEN "your-github-token-here"
```

### List stored secrets (keys only):
```bash
secret_list
```

### Secrets are automatically exported in new shell sessions.

## Security Hierarchy (Most → Least Secure)

### 1. 🔐 Password Manager with CLI (Most Secure)
```bash
# 1Password CLI
export OPENAI_API_KEY=$(op item get "OpenAI API" --fields api_key)

# Bitwarden CLI  
export OPENAI_API_KEY=$(bw get item "openai" | jq -r '.fields[0].value')
```

**Pros:** Multi-device sync, audit logs, team sharing, zero-knowledge encryption
**Cons:** Requires additional setup and CLI tools

### 2. 🔑 macOS Keychain (Recommended)
```bash
# This is what secrets.sh uses internally
security add-generic-password -a "$USER" -s "dev-secrets-OPENAI_API_KEY" -w "key"
export OPENAI_API_KEY=$(security find-generic-password -a "$USER" -s "dev-secrets-OPENAI_API_KEY" -w)
```

**Pros:** Built-in, secure, no additional tools needed
**Cons:** macOS-only, local storage only

### 3. 📁 Encrypted .env Files (Good)
```bash
# Using GPG encryption
gpg --symmetric --cipher-algo AES256 .env  # Creates .env.gpg
gpg --decrypt .env.gpg > .env              # Decrypt when needed
source .env
rm .env  # Remove plaintext after use
```

**Pros:** Portable, version controllable (encrypted version)
**Cons:** Manual encryption/decryption, key management complexity

### 4. 🏠 Local .env Files (Basic)
```bash
# .env file (NEVER commit this)
export OPENAI_API_KEY="your-key-here"
source .env
```

**Pros:** Simple, widely supported
**Cons:** Plaintext storage, easy to accidentally commit

### 5. ❌ Environment Variables (Least Secure)
```bash
export OPENAI_API_KEY="your-key-here"
```

**Pros:** Simple
**Cons:** Visible in process list, shell history, easily leaked

## What NOT to Do ❌

1. **Never hardcode secrets in files:**
   ```json
   // DON'T DO THIS
   {
     "env": {
       "OPENAI_API_KEY": "sk-proj-abc123..."
     }
   }
   ```

2. **Never commit secrets to git:**
   ```bash
   # Always check before committing
   git diff --cached | grep -i "api.*key\|secret\|token\|password"
   ```

3. **Never put secrets in URLs:**
   ```bash
   # DON'T DO THIS
   curl "https://api.openai.com/v1/models?api_key=sk-proj-abc123"
   ```

4. **Never share secrets in chat/email/issues**

## Additional Security Measures

### 1. API Key Rotation
Regularly rotate your API keys:
```bash
# Update key in keychain
secret_set OPENAI_API_KEY "new-key-here"
# Regenerate configs
./generate-mcp-config.sh
```

### 2. Principle of Least Privilege
- Use read-only tokens when possible
- Scope API keys to specific services
- Create separate keys for different environments

### 3. Environment Separation
```bash
# Different keys for different environments
secret_set OPENAI_API_KEY_DEV "dev-key"
secret_set OPENAI_API_KEY_PROD "prod-key"

# Use appropriate key based on context
export OPENAI_API_KEY="${OPENAI_API_KEY_PROD}"
```

### 4. Monitoring and Auditing
- Monitor API key usage in your service dashboards
- Set up billing alerts
- Review access logs regularly
- Revoke unused keys immediately

### 5. Git Security
Add to your global `.gitignore`:
```bash
# Already included in dotfiles/gitignore_global
.env
.env.local
*.key
*.secret
*credentials*
```

Use git hooks to prevent secret commits:
```bash
# In .git/hooks/pre-commit
#!/bin/sh
git diff --cached --name-only | xargs grep -l "sk-proj-\|ghp_\|api.*key" && echo "🚨 Secret detected!" && exit 1
```

## Emergency: Secret Leaked

If you accidentally commit a secret:

1. **Immediately revoke the key** in the service dashboard
2. **Remove from git history:**
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/file' \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. **Generate new key** and update your keychain
4. **Force push** (if you have permission)
5. **Notify team members** to pull the cleaned history

## Related Files

- `macos-setup/scripts/secrets.sh` - Keychain management functions
- `vibe/` - MCP configuration and deployment
- `SECURITY.md` - This guide

## Verification

Check your security setup:
```bash
# Verify secrets are not in plaintext files
rg -i "sk-proj|ghp_" ~/Developer/repo/ --type-not binary

# Check git history for secrets (in repo root)
git log -p | grep -i "api.*key\|secret\|token" || echo "✓ No secrets found"

# Verify keychain secrets
secret_list
```