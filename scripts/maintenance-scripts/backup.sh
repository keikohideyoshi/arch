#!/bin/bash

# Backup destination directory
backup_dir="/home/drszigetib/Mount/Keiko/backup/"

# System directories to backup
backup_sources=(
    "/etc"
    "/home"
    "/var"
    # Add any additional directories you want to backup
)

# Directories to exclude from backup
exclude_dirs=(
    "/home/drszigetib/Letöltések/"
    "/home/drszigetib/Games/"
    #"/path/to/exclude/dir2"
    # Add any additional directories to exclude
)

# Backup file name format
backup_filename="system_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

# Create backup
backup() {
    # Create a temporary directory for the backup
    temp_dir=$(mktemp -d)
    
    echo "Creating system backup..."
    
    # Copy the specified directories to the temporary directory, excluding the specified directories
    for source in "${backup_sources[@]}"; do
        rsync -a --exclude-from=<(printf '%s\n' "${exclude_dirs[@]}") "$source" "$temp_dir"
    done
    
    # Create a compressed tarball of the backup
    tar -czf "${backup_dir}/${backup_filename}" -C "$temp_dir" .
    
    # Clean up temporary directory
    rm -rf "$temp_dir"
    
    echo "Backup created successfully: ${backup_dir}/${backup_filename}"
}

# Verify backup directory exists
if [[ ! -d "$backup_dir" ]]; then
    echo "Backup directory does not exist: $backup_dir"
    exit 1
fi

# Prompt for confirmation
read -p "This will create a system backup. Are you sure? [Y/N]: " choice
if [[ $choice != "Y" && $choice != "y" ]]; then
    echo "Backup operation cancelled."
    exit 0
fi

# Perform the backup
backup
