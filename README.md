# Bash Release Build Script

A simple Bash utility for preparing a release build from a `source/` directory. The script reads the release version from `source/changelog.md`, asks for confirmation, and copies regular files into `build/` **except `secretinfo.md`**, which is intended to remain private.

## Requirements

- Bash and standard command-line tools (`head`, `cp`, `ls`, `mkdir`, and `rm`)
- A `source/` directory containing `changelog.md`
- `script.sh` located next to the `source/` directory

## Project Structure

```text
project/
├── script.sh
├── README.md
├── source/
│   ├── changelog.md
│   ├── README.md
│   ├── secretinfo.md
│   └── other-files.txt
└── build/                  # Created automatically if missing
```

The names above are examples. Only the `source/` directory and its `changelog.md` file are required for the script to run.

## Getting Started

1. Add or update the version on the **first line** of `source/changelog.md` using this format:

   ```markdown
   ## 1.1.1
   ```

2. From the project directory, make the script executable (once):

   ```bash
   chmod +x script.sh
   ```

3. Run the build script:

   ```bash
   ./script.sh
   ```

4. At the prompt, enter **`1`** to proceed or **`0`** to cancel.

The script can also be launched from another working directory; it locates the folders relative to its own file location.

## How It Works

1. Prints a welcome message.
2. Reads the first line of `source/changelog.md` and extracts the second whitespace-separated value as the release version.
3. Displays the version and prompts you to confirm that the changelog has been updated.
4. If confirmed, creates `build/` if needed and removes an existing `build/secretinfo.md` left from an older build.
5. Iterates over regular files directly inside `source/`, skipping `source/secretinfo.md` and copying the others to `build/`.
6. Lists the files in `build/` and returns to the project directory.

If you enter anything other than `1`, the script prints `Please come back when you are ready` and makes no build changes.

## Example Output

```text
Welcome to the release build script!
You are building version 1.1.1.
Have you updated changelog.md? Enter 1 to continue or 0 to exit: 1
OK
Found: source/README.md
Copying source/README.md to build/
Found: source/changelog.md
Copying source/changelog.md to build/
Found: source/secretinfo.md
Not copying source/secretinfo.md (private information).
Files in build/ for version 1.1.1:
README.md
changelog.md
```

Actual file names will depend on the contents of your `source/` directory. You can inspect the results with:

```bash
ls -la build/
```

## Important Limitations

- **Non-recursive:** The script copies only regular files immediately inside `source/`. It does not copy nested directories or their contents.
- **Hidden files:** Files with names beginning with a dot (such as `.env`) are not matched by the default `source/*` pattern.
- **Existing builds:** It does **not** clear the entire `build/` directory. Older files can remain even if they have been removed from `source/`. Review the output before publishing.
- **Sensitive information:** The exclusion applies specifically to a file named `source/secretinfo.md`. Other files are copied without inspection, so check for additional secrets before distributing a build.
- **Version validation:** The script checks that a second value exists on the first line but does not validate semantic versioning or enforce the `##` prefix.

## Troubleshooting

**`Permission denied` when running `./script.sh`:** Run `chmod +x script.sh` or use `bash script.sh`.

**`source/changelog.md was not found`:** Create the file inside `source/` next to the script and add the version heading as its first line.

**`expected a version on the first line`:** Ensure the first line follows the form `## 1.1.1` (without a blank line above it).

**Unexpected files remain in `build/`:** The script does not remove old build files other than `secretinfo.md`. Clean and recreate the directory if you need a fresh build, after checking that it contains nothing you need.
