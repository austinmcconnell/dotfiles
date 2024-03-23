# Opening and closing

## Launching vim

- `vim`
- `vim .`
- `vim file1.txt file2.txt`: open vim and load file1.txt and file2.txt
- `vim -o *`: open all files in current directory in vertical splits

## Files

`:e(dit) {file}`: edit {file}

## Quitting vim

- `q`: quit
- `q!`: quit without saving
- `qa`: quit all
- `wq`: write current file and close window

## Suspending vim

- `C-z>`: get back to terminal without quitting vim (sends vim to background)
- `fg`: type in terminal to return to session (if there is a single backgrounded session)
- `fg [job_id]`: return to a speific vim session
- `jobs`: type in terminal to list all suspended vim sessions
