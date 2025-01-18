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
The requirement that I had was to have a utility which could: 

1. Create some kind of a jobset where you could enqueue a list of jobs.
2. Since logs are important, be able to log the output and errors of each job.
3. Since knowing success or failure of the entire jobset as well as an individual job in it is important, be able to show that.
4. Be able to run multiple programs in parallel.
5. Be able to increase and decrease the number of parallel job count that can be executed at a time while it is running.
6. Be able to monitor the running jobs and start new ones from the list of pending ones.

## The result
This repository is the result of an attempt to solve the problem outlined above. Once the work is complete to an extent that is presentable, I will write some details about it here.

### The states of a single job
A single/individual job can be in one of the following states: 

1. `pending`: The job is not yet started.
2. `running`: The job is being executed right now.
3. `errored`: The job has errored out and can be rescheduled or retired.
4. `success`: The job succeeded.

### Picking up another job
When a job is enqueued, it is internally given a number and the state is set to `pending`. The monitor keeps checking for job status every few seconds. If the number of jobs that are running is less than the PJC (Parallel Job Count), then the monitor will go through all the jobs and check for the pending ones. The first job that is found pending is scheduled. If there is another job which is both pending and is set to `high` priority then that job is picked. If there are more than one high-priority jobs that are in `pending` state, then the one with lowest job number is scheduled for execution.

### Priorities of a job
There are just two priorities of a job that can be set:

1. `normal`: Normal priority job. This is the default priority of a new job.
2. `high`: High priority job. If this is set, then the job is high-priority and whenever the monitor can schedule a new job, a high-priority job if found in pending state will always be picked up above another, normal priority job.

















