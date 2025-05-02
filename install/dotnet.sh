#!/bin/bash

if is-executable dotnet; then
    echo "**************************************************"
    echo "Configuring .NET"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing .NET"
        echo "**************************************************"
        brew install dotnet
    elif is-debian; then
        echo "**************************************************"
        echo "Installing .NET"
        echo "**************************************************"
        # Add Microsoft package repository
        wget "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -O packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb

        # Install .NET SDK
        sudo apt-get update
        sudo apt-get install -y dotnet-sdk-8.0
    else
        echo "**************************************************"
        echo "Skipping .NET installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

# Create XDG directories for .NET and NuGet
mkdir -p "$XDG_CONFIG_HOME/nuget"
mkdir -p "$XDG_DATA_HOME/dotnet"
mkdir -p "$XDG_DATA_HOME/nuget/packages"
mkdir -p "$XDG_CACHE_HOME/nuget/http-cache"
mkdir -p "$XDG_CACHE_HOME/nuget/plugins-cache"
mkdir -p "$XDG_DATA_HOME/omnisharp"

# Migrate NuGet configuration
if [[ -f "$HOME/.nuget/NuGet/NuGet.Config" ]]; then
    echo "Moving existing NuGet.Config to XDG_CONFIG_HOME/nuget"
    cp "$HOME/.nuget/NuGet/NuGet.Config" "$XDG_CONFIG_HOME/nuget/NuGet.Config"
    rm "$HOME/.nuget/NuGet/NuGet.Config"
fi

# Migrate NuGet packages
if [[ -d "$HOME/.nuget/packages" && "$(ls -A "$HOME/.nuget/packages" 2>/dev/null)" ]]; then
    echo "Moving existing NuGet packages to XDG_DATA_HOME/nuget/packages"
    cp -r "$HOME/.nuget/packages/"* "$XDG_DATA_HOME/nuget/packages/"
    rm -rf "$HOME/.nuget/packages"
fi

# Clean up NuGet directory
if [[ -d "$HOME/.nuget" && -z "$(ls -A "$HOME/.nuget" 2>/dev/null)" ]]; then
    rm -rf "$HOME/.nuget"
fi

# Migrate .NET user-level cache and tools
if [[ -d "$HOME/.dotnet" ]]; then
    echo "Moving existing .NET user-level files to XDG_DATA_HOME/dotnet"
    # Copy tools directory if it exists
    if [[ -d "$HOME/.dotnet/tools" && "$(ls -A "$HOME/.dotnet/tools" 2>/dev/null)" ]]; then
        mkdir -p "$XDG_DATA_HOME/dotnet/tools"
        cp -r "$HOME/.dotnet/tools/"* "$XDG_DATA_HOME/dotnet/tools/"
    fi

    # Copy other important directories
    for dir in sdk-advertising symbolcache TelemetryStorageService; do
        if [[ -d "$HOME/.dotnet/$dir" && "$(ls -A "$HOME/.dotnet/$dir" 2>/dev/null)" ]]; then
            mkdir -p "$XDG_DATA_HOME/dotnet/$dir"
            cp -r "$HOME/.dotnet/$dir/"* "$XDG_DATA_HOME/dotnet/$dir/"
        fi
    done

    # Copy sentinel files and other configuration files
    find "$HOME/.dotnet" -maxdepth 1 -type f -exec cp {} "$XDG_DATA_HOME/dotnet/" \;

    # Remove the original .dotnet directory after migration
    rm -rf "$HOME/.dotnet"
fi

# Migrate OmniSharp directory if it exists
if [[ -d "$HOME/.omnisharp" && "$(ls -A "$HOME/.omnisharp" 2>/dev/null)" ]]; then
    echo "Moving existing OmniSharp directory to XDG_DATA_HOME/omnisharp"
    mkdir -p "$XDG_DATA_HOME/omnisharp"
    cp -r "$HOME/.omnisharp/"* "$XDG_DATA_HOME/omnisharp/"
    rm -rf "$HOME/.omnisharp"
elif [[ -d "$HOME/.omnisharp" ]]; then
    # Directory exists but is empty
    rm -rf "$HOME/.omnisharp"
fi

echo ".NET and NuGet configured to use XDG directories"
