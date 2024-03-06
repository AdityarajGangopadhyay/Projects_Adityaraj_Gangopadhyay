#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

volatile int job_index = -1;
volatile int current_job_pid = -2;

typedef struct Job{
	pid_t pid;
    char* curr_s;
    char command[99999];
    int bg;
} job;

job* volatile jobs;

void reverse(char s[]){
    int i, j;
    char c;

    for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

void itoa(int n, char s[]){
    int i, sign;

    if ((sign = n) < 0)
        n = -n;
    i = 0;
    do {
        s[i++] = n % 10 + '0';
    } while ((n /= 10) > 0);
    if (sign < 0)
        s[i++] = '-';
    s[i] = '\0';
    reverse(s);
}

void other_handler(int sig, siginfo_t *info, void *ucontext){
    if(current_job_pid==-2){
        write(STDOUT_FILENO, "\n", 1);
        write(STDOUT_FILENO, "> ", 2);
        return;
    }
    if(sig==2){
        killpg(getpgid(current_job_pid), SIGINT);
    }
    else{
        killpg(getpgid(current_job_pid), SIGTSTP);
    }
}
void child_handler(int sig, siginfo_t *info, void *ucontext){
    if(info->si_status==18){
        return;
    }
    pid_t cpid;
    int wstatus;

    if(current_job_pid != info->si_pid){
        cpid = waitpid(-1, &wstatus, WUNTRACED);
    }
    else{
        return;
    }
    int temp_index;

    for(int i=0; i<job_index+1; i++){
        if(jobs[i].pid == cpid){
            temp_index = i;
        }
    }

    if(WIFEXITED(wstatus)){
        jobs[temp_index].curr_s = "Terminated";
        jobs[temp_index].bg = 0;
    }
    else if(WIFSIGNALED(wstatus)){
        jobs[temp_index].curr_s = "Terminated";
        jobs[temp_index].bg = 0;
        
        write(STDOUT_FILENO, "\n", 1);
        write(STDOUT_FILENO, "[", 1);
        char string[99999] = {'\0'};
        itoa((temp_index+1), string);
        int string_index = 0;
        while(string[string_index] != '\0'){
            write(STDOUT_FILENO, &string[string_index], 1);
            string_index++;
        }
        write(STDOUT_FILENO, "] ", 2);
        char string_2[99999] = {'\0'};
        itoa(cpid, string_2);
        string_index = 0;
        while(string_2[string_index] != '\0'){
            write(STDOUT_FILENO, &string_2[string_index], 1);
            string_index++;
        }
        write(STDOUT_FILENO, " terminated by signal ", 22);
        char string_3[99999] = {'\0'};
        itoa((WTERMSIG(wstatus)), string_3);
        string_index = 0;
        while(string_3[string_index] != '\0'){
            write(STDOUT_FILENO, &string_3[string_index], 1);
            string_index++;
        }
        write(STDOUT_FILENO, "\n", 1);
        write(STDOUT_FILENO, "> ", 2);
    }
    else if(WIFSTOPPED(wstatus)){
        jobs[temp_index].curr_s = "Stopped";
        jobs[temp_index].bg = 0;
        write(STDOUT_FILENO, "\n", 1);
    }
}


int main(int argc, char* argv[]){
    sigset_t main_mask;
    sigemptyset(&main_mask);
    sigaddset(&main_mask, SIGINT);
    sigaddset(&main_mask, SIGTSTP);

    struct sigaction action;
    action.sa_flags = SA_NODEFER | SA_SIGINFO | SA_RESTART;
    action.sa_mask = main_mask;
    action.sa_sigaction = child_handler;

    struct sigaction action2;
    action2.sa_flags = SA_SIGINFO | SA_RESTART;
    action2.sa_mask = main_mask;
    action2.sa_sigaction = other_handler;
    
    sigaction(SIGCHLD, &action, NULL);

    sigaction(SIGINT, &action2, NULL);
    sigaction(SIGTSTP, &action2, NULL);

    char* input;
    size_t size;
    char* aftergap;
    int arg_index;
    jobs = malloc(sizeof(job));
    
    while(1){
        printf("> ");
        getline(&input, &size, stdin);

        char main_command[99999];
        main_command[0] = '\0';
        sscanf(input, "%s", main_command);
        
        if(((strcasecmp(main_command, "exit"))==0) || feof(stdin)){
            if(feof(stdin)){
                printf("\n");
            }
            break;
        }
        if(main_command[0]=='\0'){
        }
        else if((strcasecmp(main_command, "bg"))==0){
            int job_id;
            sscanf(input, "%s %%%d", main_command, &job_id);
            jobs[job_id-1].curr_s = "Running";
            jobs[job_id-1].bg = 1;
            killpg(getpgid(jobs[job_id-1].pid), SIGCONT);
        }
        else if((strcasecmp(main_command, "cd"))==0){
            char path[99999] = "";
            sscanf(input, "%s %s", main_command, path);
            int empty = 1;
            char* second_path = path;
            
            while (*second_path != '\0') {
                if (!isspace((unsigned char)*second_path)){
                    empty = 0;
                    second_path++;
                }
            }

            if(empty==1){
                chdir(getenv("HOME"));
            }
            else{
                chdir(path);
            }
            char curr_dir[99999];
            getcwd(curr_dir, 99999);
            setenv("PWD", curr_dir, 1);
        }
        else if((strcasecmp(main_command, "fg"))==0){
            int job_id;
            sscanf(input, "%s %%%d", main_command, &job_id);
            jobs[job_id-1].curr_s = "Running";
            jobs[job_id-1].bg = 0;
            int wstatus;
            current_job_pid = jobs[job_id-1].pid;
            killpg(getpgid(jobs[job_id-1].pid), SIGCONT);
            waitpid(jobs[job_id-1].pid, &wstatus, WUNTRACED);
            current_job_pid = -2;
            
            if(WIFEXITED(wstatus)){
                jobs[job_index].curr_s = "Terminated";
            }
            else if(WIFSIGNALED(wstatus)){
                jobs[job_index].curr_s = "Terminated";
                printf("\n");
                printf("[%d] %d terminated by signal %d\n", (job_index+1), jobs[job_id-1].pid, WTERMSIG(wstatus));
            }
            else if(WIFSTOPPED(wstatus)){
                jobs[job_index].curr_s = "Stopped";
                printf("\n");
            }
        }
        else if((strcasecmp(main_command, "kill"))==0){
            int job_id;
            sscanf(input, "%s %%%d", main_command, &job_id);
            jobs[job_id-1].curr_s = "Terminated";
            jobs[job_id-1].bg = 0;
            killpg(getpgid(jobs[job_id-1].pid), SIGCONT);
            killpg(getpgid(jobs[job_id-1].pid), SIGTERM);
        }
        else if((strcasecmp(main_command, "jobs"))==0){
            for(int i=0; i<(job_index+1); i++){
                if((strcasecmp(jobs[i].curr_s, "Stopped")==0) || (strcasecmp(jobs[i].curr_s, "Running")==0)){
                    printf("[%d] %d %s %s", (i+1), jobs[i].pid, jobs[i].curr_s, jobs[i].command);
                    if((strcasecmp(jobs[i].curr_s, "Running"))==0){
                        if(jobs[i].bg==1){
                            printf(" &");
                        }
                    }
                    printf("\n");
                }
            }
        }
        else{
            if(strstr(input, "./")!=NULL){
                if(strstr(input, "../")!=NULL){
                    aftergap = strstr(input, "../");
                }
                else{
                    aftergap = strstr(input, "./");
                }
            }
            else if(strstr(input, "/")!=NULL){
                aftergap = strstr(input, "/");
            }
            else{
                aftergap = input;
            }

            char** args;
            args = malloc((1) * sizeof(char*));
            args[0] = malloc(99999);
            char* token = strtok(aftergap, " ");
            arg_index = 0;
            
            while(token != NULL){
                strcpy(args[arg_index], token);
                arg_index++;
                args = realloc(args, (arg_index+1) * sizeof(char*));
                args[arg_index] = malloc(99999);
                token = strtok(NULL, " ");
            }
            free(args[arg_index]);
            args[arg_index-1][strcspn(args[arg_index-1], "\n")] = 0;
            int bg = 0;
            
            if(strcasecmp(args[arg_index-1], "&") == 0){
                free(args[arg_index-1]);
                args = realloc(args, (arg_index) * sizeof(char*));
                args[arg_index-1] = NULL;
                bg = 1;
            }
            else{
                args = realloc(args, (arg_index+1) * sizeof(char*));
                args[arg_index] = NULL;
                arg_index++;
            }

            if(args[0]!=NULL){

                if(strstr(input, "/") == NULL){
                    char pathname[99999] = "/usr/bin/";
                    strcat(pathname, args[0]);

                    if(access(pathname, F_OK) == 0){
                        job_index++;
                        jobs = realloc(jobs, (job_index+1)*sizeof(job));
                        strcpy(jobs[job_index].command, args[0]);
                        strcpy(args[0], pathname);

                        if(bg==0){
                            pid_t cpid = -1;
                            jobs[job_index].bg = 0;
                            jobs[job_index].curr_s = "Running";
                            jobs[job_index].pid = cpid;
                            int wstatus;

                            if((cpid = fork())==0){
                                setpgid(0,0);
                                execv(args[0], args);
                            }
                            else{
                                current_job_pid = cpid;
                                jobs[job_index].pid = cpid;
                                waitpid(cpid, &wstatus, WUNTRACED);
                                current_job_pid = -2;
                                
                                if(WIFEXITED(wstatus)){
                                    jobs[job_index].curr_s = "Terminated";
                                }
                                else if(WIFSIGNALED(wstatus)){
                                    jobs[job_index].curr_s = "Terminated";
                                    printf("\n");
                                    printf("[%d] %d terminated by signal %d\n", (job_index+1), cpid, WTERMSIG(wstatus));
                                }
                                else if(WIFSTOPPED(wstatus)){
                                    jobs[job_index].curr_s = "Stopped";
                                    printf("\n");
                                }
                            }
                        }
                        else{
                            pid_t cpid = -1;
                            jobs[job_index].pid = cpid;
                            jobs[job_index].bg = 1;
                            jobs[job_index].curr_s = "Running";

                            if((cpid = fork())==0){
                                setpgid(0,0);
                                execv(args[0], args);
                            }
                            else{
                                jobs[job_index].pid = cpid;
                                printf("[%d] %d\n", (job_index+1), cpid);
                            }
                        }
                    }
                    else{
                        char pathname[99999] = "/bin/";
                        strcat(pathname, args[0]);

                        if(access(pathname, F_OK) == 0){
                            job_index++;
                            jobs = realloc(jobs, (job_index+1)*sizeof(job));
                            strcpy(jobs[job_index].command, args[0]);
                            strcpy(args[0], pathname);
                            
                            if(bg==0){
                                pid_t cpid = -1;
                                jobs[job_index].bg = 0;
                                jobs[job_index].curr_s = "Running";
                                jobs[job_index].pid = cpid;
                                int wstatus;

                                if((cpid = fork())==0){
                                    setpgid(0,0);
                                    execv(args[0], args);
                                }
                                else{
                                    current_job_pid = cpid;
                                    jobs[job_index].pid = cpid;
                                    waitpid(cpid, &wstatus, WUNTRACED);
                                    current_job_pid = -2;
                                    
                                    if(WIFEXITED(wstatus)){
                                        jobs[job_index].curr_s = "Terminated";
                                    }
                                    else if(WIFSIGNALED(wstatus)){
                                        jobs[job_index].curr_s = "Terminated";
                                        printf("\n");
                                        printf("[%d] %d terminated by signal %d\n", (job_index+1), cpid, WTERMSIG(wstatus));
                                    }
                                    else if(WIFSTOPPED(wstatus)){
                                        jobs[job_index].curr_s = "Stopped";
                                        printf("\n");
                                    }
                                }
                            }
                            else{
                                pid_t cpid = -1;
                                jobs[job_index].pid = cpid;
                                jobs[job_index].bg = 1;
                                jobs[job_index].curr_s = "Running";

                                if((cpid = fork())==0){
                                    setpgid(0,0);
                                    execv(args[0], args);
                                }
                                else{
                                    jobs[job_index].pid = cpid;
                                    printf("[%d] %d\n", (job_index+1), cpid);
                                }
                            }
                        }
                        else{
                            printf("%s: command not found\n", args[0]);
                        }
                    }
                }
                else{
                    if(access(args[0], F_OK) == 0){

                        if(bg==0){
                            pid_t cpid = -1;
                            job_index++;
                            jobs = realloc(jobs, (job_index+1)*sizeof(job));
                            strcpy(jobs[job_index].command, args[0]);
                            jobs[job_index].bg = 0;
                            jobs[job_index].curr_s = "Running";
                            jobs[job_index].pid = cpid;
                            int wstatus;

                            if((cpid = fork())==0){
                                setpgid(0,0);
                                execv(args[0], args);
                            }
                            else{
                                current_job_pid = cpid;
                                jobs[job_index].pid = cpid;
                                waitpid(cpid, &wstatus, WUNTRACED);
                                current_job_pid = -2;
                                
                                if(WIFEXITED(wstatus)){
                                    jobs[job_index].curr_s = "Terminated";
                                }
                                else if(WIFSIGNALED(wstatus)){
                                    jobs[job_index].curr_s = "Terminated";
                                    printf("\n");
                                    printf("[%d] %d terminated by signal %d\n", (job_index+1), cpid, WTERMSIG(wstatus));
                                }
                                else if(WIFSTOPPED(wstatus)){
                                    jobs[job_index].curr_s = "Stopped";
                                    printf("\n");
                                }
                            }
                        }
                        else{
                            pid_t cpid = -1;
                            job_index++;
                            jobs = realloc(jobs, (job_index+1)*sizeof(job));
                            jobs[job_index].pid = cpid;
                            strcpy(jobs[job_index].command, args[0]);
                            jobs[job_index].bg = 1;
                            jobs[job_index].curr_s = "Running";

                            if((cpid = fork())==0){
                                setpgid(0,0);
                                execv(args[0], args);
                            }
                            else{
                                jobs[job_index].pid = cpid;
                                printf("[%d] %d\n", (job_index+1), cpid);
                            }
                        }
                    }
                    else{
                        printf("%s: No such file or directory\n", args[0]);
                    }
                }
            }

            for(int i=0; i<arg_index; i++){
                free(args[i]);
            }
            free(args);
        }
    }
    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, SIGCHLD);
    sigprocmask(SIG_BLOCK, &mask, NULL);

    for(int i=0; i<(job_index+1); i++){
        if(strcasecmp(jobs[i].curr_s, "Stopped")==0){
            killpg(getpgid(jobs[i].pid), SIGHUP);
            killpg(getpgid(jobs[i].pid), SIGCONT);
        }
        else if(strcasecmp(jobs[i].curr_s, "Running")==0){
            killpg(getpgid(jobs[i].pid), SIGHUP);
        }
    }
    free(input);
    free(jobs);
}