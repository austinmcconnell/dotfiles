#!/usr/bin/env bash

# AI prompt management functions

# Store a prompt
ai-save() {
    local name="$1"
    local prompt_dir="$HOME/.dotfiles/etc/ai-prompts"

    if [[ -z "$name" ]]; then
        echo "Usage: ai-save <prompt-name>"
        echo "Then paste your prompt and press Ctrl+D"
        return 1
    fi

    mkdir -p "$prompt_dir"
    echo "Enter your prompt (press Ctrl+D when done):"
    cat >"$prompt_dir/$name.txt"
    echo "Prompt saved as '$name'"
}

# List available prompts
ai-list() {
    local prompt_dir="$HOME/.dotfiles/etc/ai-prompts"

    if [[ ! -d "$prompt_dir" ]]; then
        echo "No prompts directory found. Use 'ai-save' to create your first prompt."
        return 1
    fi

    echo "Available prompts:"
    find "$prompt_dir" -name "*.txt" -type f 2>/dev/null | sed 's|.*/||; s|\.txt$||' | sort
}

# Use a prompt (copy to clipboard)
ai-use() {
    local name="$1"
    local prompt_dir="$HOME/.dotfiles/etc/ai-prompts"
    local prompt_file="$prompt_dir/$name.txt"

    if [[ -z "$name" ]]; then
        echo "Usage: ai-use <prompt-name>"
        echo "Available prompts:"
        ai-list
        return 1
    fi

    if [[ ! -f "$prompt_file" ]]; then
        echo "Prompt '$name' not found."
        echo "Available prompts:"
        ai-list
        return 1
    fi

    # Copy to clipboard (macOS)
    if command -v pbcopy >/dev/null 2>&1; then
        pbcopy <"$prompt_file"
        echo "Prompt '$name' copied to clipboard"
    # Copy to clipboard (Linux with xclip)
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard <"$prompt_file"
        echo "Prompt '$name' copied to clipboard"
    else
        echo "Clipboard tool not found. Here's your prompt:"
        echo "----------------------------------------"
        cat "$prompt_file"
        echo "----------------------------------------"
    fi
}

# Edit a prompt
ai-edit() {
    local name="$1"
    local prompt_dir="$HOME/.dotfiles/etc/ai-prompts"
    local prompt_file="$prompt_dir/$name.txt"

    if [[ -z "$name" ]]; then
        echo "Usage: ai-edit <prompt-name>"
        echo "Available prompts:"
        ai-list
        return 1
    fi

    mkdir -p "$prompt_dir"
    ${EDITOR:-vim} "$prompt_file"
}

# Show a prompt
ai-show() {
    local name="$1"
    local prompt_dir="$HOME/.dotfiles/etc/ai-prompts"
    local prompt_file="$prompt_dir/$name.txt"

    if [[ -z "$name" ]]; then
        echo "Usage: ai-show <prompt-name>"
        echo "Available prompts:"
        ai-list
        return 1
    fi

    if [[ ! -f "$prompt_file" ]]; then
        echo "Prompt '$name' not found."
        return 1
    fi

    echo "=== Prompt: $name ==="
    cat "$prompt_file"
}

# Delete a prompt
ai-delete() {
    local name="$1"
    local prompt_dir="$HOME/.dotfiles/etc/ai-prompts"
    local prompt_file="$prompt_dir/$name.txt"

    if [[ -z "$name" ]]; then
        echo "Usage: ai-delete <prompt-name>"
        echo "Available prompts:"
        ai-list
        return 1
    fi

    if [[ ! -f "$prompt_file" ]]; then
        echo "Prompt '$name' not found."
        return 1
    fi

    echo "Are you sure you want to delete prompt '$name'? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        rm "$prompt_file"
        echo "Prompt '$name' deleted"
    else
        echo "Deletion cancelled"
    fi
}

# Help function
ai-help() {
    echo "AI Prompt Management Commands:"
    echo ""
    echo "  ai-save <name>    Save a new prompt (will prompt for input)"
    echo "  ai-use <name>     Copy prompt to clipboard"
    echo "  ai-list           List all available prompts"
    echo "  ai-show <name>    Display a prompt"
    echo "  ai-edit <name>    Edit a prompt in your default editor"
    echo "  ai-delete <name>  Delete a prompt"
    echo "  ai-help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  ai-save code-review"
    echo "  ai-use code-review"
    echo "  ai-edit code-review"
    echo ""
    echo "Works with any AI chat service: Amazon Q, Claude, ChatGPT, Gemini, etc."
}
