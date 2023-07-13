/bin/ls
a.out
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c
out.res
out_res.res
test.sh

/bin/cat microshell.c
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   microshell.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: hgeissle <hgeissle@student.s19.be>         +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/07/12 16:21:50 by hgeissle          #+#    #+#             */
/*   Updated: 2023/07/13 13:11:48 by hgeissle         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int	ft_strlen(char *str)
{
	int		i;

	i = 0;
	while (str[i])
		i++;
	return (i);
}

void	err(char *msg, char *arg)
{
	write(2, msg, ft_strlen(msg));
	if (arg)
		write(2, arg, ft_strlen(arg));
	write(2, "\n", 1);
    exit (1);
}

int	exec(char *path, char **args, char **envp, int in, int out)
{
	if ((strcmp(path, "cd") == 0) && args[1] && !args[2])
	{
		if (!args[1] || args[2])
			err("error: cd: bad arguments", 0);
		if (chdir(args[1]) == -1)
			err("error: cd: cannot change directory to ", args[1]);
		exit (0);
	}
	if (out)
		dup2(out, 1);
	if (in)
		dup2(in, 0);
	if (execve(path, args, envp) == -1)
		err("error: cannot execute ", path);
	return (0);
}

int	main(int ac,  char **av, char **envp)
{
	int		i;
	char	*cmd_path;
	int		end[2];
	int		in;
	int		out;
	char	**args;
	int		pid;
	int		status;

	if (ac > 1)
	{
		end[0] = 0;
		end[1] = 0;
		cmd_path = 0;
		in = 0;
		out = 0;
		i = 1;
		while (i < ac)
		{
			if (!cmd_path)
			{
				cmd_path = av[i];
				args = &av[i];
			}
			if (strcmp(av[i], "|") == 0)
			{
				if (pipe(end))
					err("error: fatal", 0);
				out = end[1];
				pid = fork();
				if (!pid)
				{
					av[i] = 0;
					exec(cmd_path, args, envp, in, out);
				}
				waitpid(pid, &status, 0);
				if (in)
					close(in);
				close(out);
				cmd_path = 0;
				out = 0;
				in = end[0];
			}
			if ((strcmp(av[i], ";") == 0) || (i == ac - 1))
			{
				out = 0;
				pid = fork();
				if (!pid)
				{
					if (i != ac - 1)
						av[i] = 0;
					exec(cmd_path, args, envp, in, out);
				}
				waitpid(pid, &status, 0);
				if (in)
					close(in);
				cmd_path = 0;
				in = 0;
			}
			i++;
		}
	}
	return (0);
}

/bin/ls microshell.c
microshell.c

/bin/ls salut

;

; ;

; ; /bin/echo OK
OK

; ; /bin/echo OK ;
OK ;

; ; /bin/echo OK ; ;
OK

; ; /bin/echo OK ; ; ; /bin/echo OK
OK
OK

/bin/ls | /usr/bin/grep microshell
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c

/bin/ls | /usr/bin/grep microshell | /usr/bin/grep micro
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c

/bin/ls | /usr/bin/grep microshell | /usr/bin/grep micro | /usr/bin/grep shell | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c

/bin/ls | /usr/bin/grep microshell | /usr/bin/grep micro | /usr/bin/grep shell | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep micro | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell | /usr/bin/grep shell
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c

/bin/ls ewqew | /usr/bin/grep micro | /bin/cat -n ; /bin/echo dernier ; /bin/echo
dernier


/bin/ls | /usr/bin/grep micro | /bin/cat -n ; /bin/echo dernier ; /bin/echo ftest ;
     1	microshell
     2	microshell copy.c
     3	microshell.c
     4	microshell.dSYM
     5	microshell.h
     6	microshell_ref.c
dernier
ftest ;

/bin/echo ftest ; /bin/echo ftewerwerwerst ; /bin/echo werwerwer ; /bin/echo qweqweqweqew ; /bin/echo qwewqeqrtregrfyukui ;
ftest
ftewerwerwerst
werwerwer
qweqweqweqew
qwewqeqrtregrfyukui ;

/bin/ls ftest ; /bin/ls ; /bin/ls werwer ; /bin/ls microshell.c ; /bin/ls subject.fr.txt ;
a.out
leaks.res
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c
out.res
out_res.res
test.sh
microshell.c

/bin/ls | /usr/bin/grep micro ; /bin/ls | /usr/bin/grep micro ; /bin/ls | /usr/bin/grep micro ; /bin/ls | /usr/bin/grep micro ;
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c
microshell
microshell copy.c
microshell.c
microshell.dSYM
microshell.h
microshell_ref.c

/bin/cat subject.fr.txt | /usr/bin/grep a | /usr/bin/grep b ; /bin/cat subject.fr.txt ;

/bin/cat subject.fr.txt | /usr/bin/grep a | /usr/bin/grep w ; /bin/cat subject.fr.txt ;

/bin/cat subject.fr.txt | /usr/bin/grep a | /usr/bin/grep w ; /bin/cat subject.fr.txt

/bin/cat subject.fr.txt ; /bin/cat subject.fr.txt | /usr/bin/grep a | /usr/bin/grep b | /usr/bin/grep z ; /bin/cat subject.fr.txt

; /bin/cat subject.fr.txt ; /bin/cat subject.fr.txt | /usr/bin/grep a | /usr/bin/grep b | /usr/bin/grep z ; /bin/cat subject.fr.txt

blah | /bin/echo OK
OK

blah | /bin/echo OK ;
OK ;

