# ZSHY PLL (The Parallel Job Runner)

This program is a set of scripts which allows you to sequence a number of commands (or jobs, as they are referred to in here) and run a preset number of them in parallel. You might be confused with that introduction so let me state the same using the real example which inspired the creation of this tool.

## The inspiration
I needed to download a bunch of SQL files (more than a dozen) using the `pg_dump` program (which can create dumps of PostgreSQL databases) into individual `.sql` files. Some of these files can be small, some very large. Some take relatively less time, some way more. Some large files can utilize my full bandwidth while some other large files download pretty slow. Once these files were downloaded, I would compress them and re-upload them at another location where other developers on the team could do it. Once that is done, I would use those dumps to restore those files into a database.

Since this was to be done again and again, I wrote a script to automate the entire thing. However given the size of data (more than 50 GB) that needed to be downloaded, I needed to parallelize the download, the zipping, the upload and the restoration so that I could get the entire task done in as less time as possible. The ideal situation would be to divide the task into parallel sequence of actions for each database dump being processed like this:

    - Download the dump file
    - Then, compress the dump file
    - Then, upload the dump file 
    - And in parallel - restore the dump file

Once all the files have been processed, the task as succeeded. If any step for any file failed, we can retry those and inspect the logs or whatever would be the next steps.

## The requirement



