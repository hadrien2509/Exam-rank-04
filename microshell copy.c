/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   microshell.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: hgeissle <hgeissle@student.s19.be>         +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/07/12 16:21:50 by hgeissle          #+#    #+#             */
/*   Updated: 2023/07/13 12:07:20 by hgeissle         ###   ########.fr       */
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
	execve(path, args, envp);
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
