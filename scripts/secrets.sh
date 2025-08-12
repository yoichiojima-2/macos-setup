#!/usr/bin/env bash

# Secrets management utility using macOS Keychain
# Source this file in your .zshrc: source ~/Developer/repo/dotfiles/secrets.sh

# Service name for grouping secrets
KEYCHAIN_SERVICE="dev-secrets"

# Function to store a secret
secret_set() {
    local key="${1}"
    local value="${2}"
    
    if [[ -z "$key" ]] || [[ -z "$value" ]]; then
        echo "Usage: secret_set KEY VALUE" >&2
        return 1
    fi
    
    security add-generic-password \
        -a "$USER" \
        -s "${KEYCHAIN_SERVICE}-${key}" \
        -w "$value" \
        -U \
        2>/dev/null
    
    echo "✓ Secret '${key}' stored in keychain"
}

# Function to retrieve a secret
secret_get() {
    local key="${1}"
    
    if [[ -z "$key" ]]; then
        echo "Usage: secret_get KEY" >&2
        return 1
    fi
    
    security find-generic-password \
        -a "$USER" \
        -s "${KEYCHAIN_SERVICE}-${key}" \
        -w \
        2>/dev/null
}

# Function to delete a secret
secret_delete() {
    local key="${1}"
    
    if [[ -z "$key" ]]; then
        echo "Usage: secret_delete KEY" >&2
        return 1
    fi
    
    security delete-generic-password \
        -a "$USER" \
        -s "${KEYCHAIN_SERVICE}-${key}" \
        2>/dev/null
    
    echo "✓ Secret '${key}' deleted from keychain"
}

# Function to list all secrets (keys only, not values)
secret_list() {
    security dump-keychain | grep "${KEYCHAIN_SERVICE}" | \
        sed -n 's/.*"svce"<blob>="\(.*\)"/\1/p' | \
        sed "s/${KEYCHAIN_SERVICE}-//" | \
        sort -u
}

# Function to export a secret as environment variable
secret_export() {
    local key="${1}"
    local env_var="${2:-$key}"  # Use key as env var name if not specified
    
    if [[ -z "$key" ]]; then
        echo "Usage: secret_export KEY [ENV_VAR_NAME]" >&2
        return 1
    fi
    
    local value=$(secret_get "$key")
    
    if [[ -n "$value" ]]; then
        export "${env_var}=${value}"
        echo "✓ Exported ${env_var}"
    else
        echo "✗ Secret '${key}' not found" >&2
        return 1
    fi
}

# Function to initialize common secrets
secrets_init() {
    echo "Initializing development secrets..."
    
    # Check for required secrets
    local required_secrets=(
        "OPENAI_API_KEY"
        "GITHUB_TOKEN"
    )
    
    local missing=()
    for secret in "${required_secrets[@]}"; do
        if ! secret_get "$secret" >/dev/null 2>&1; then
            missing+=("$secret")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "⚠ Missing secrets: ${missing[*]}"
        echo "Use 'secret_set KEY VALUE' to add them"
    else
        echo "✓ All required secrets found"
    fi
}

# Auto-export common secrets if they exist
secrets_auto_export() {
    # OpenAI API Key
    if value=$(secret_get "OPENAI_API_KEY" 2>/dev/null); then
        export OPENAI_API_KEY="$value"
    fi
    
    # GitHub Token
    if value=$(secret_get "GITHUB_TOKEN" 2>/dev/null); then
        export GITHUB_TOKEN="$value"
    fi
    
    # Add more auto-exports as needed
}

# Interactive secret setup
secret_setup() {
    echo "Interactive Secret Setup"
    echo "========================"
    echo ""
    
    read -p "Enter OpenAI API Key (or press Enter to skip): " -s openai_key
    echo
    if [[ -n "$openai_key" ]]; then
        secret_set "OPENAI_API_KEY" "$openai_key"
    fi
    
    read -p "Enter GitHub Token (or press Enter to skip): " -s github_token
    echo
    if [[ -n "$github_token" ]]; then
        secret_set "GITHUB_TOKEN" "$github_token"
    fi
    
    echo ""
    echo "Setup complete! Secrets are stored in macOS Keychain."
    echo "They will be automatically loaded in new shell sessions."
}

# Aliases for convenience
alias sec-set='secret_set'
alias sec-get='secret_get'
alias sec-del='secret_delete'
alias sec-list='secret_list'
alias sec-export='secret_export'
alias sec-init='secrets_init'
alias sec-setup='secret_setup'

# Auto-export secrets when sourced (optional - comment out if you prefer manual)
secrets_auto_export