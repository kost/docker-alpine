FROM alpine-bash:latest

COPY ./etc/inputrc /etc/inputrc

# perl is required by git-submodule
# less makes git log/diff colorful
RUN apk add --no-cache bash-completion docker-bash-completion openssh-client git perl make vim less htop iftop && \
    echo '\
        . /etc/profile ; \
        PS1='\''\[\e[01;33m\][\h \u:\[\e[01;34m\]\w\[\e[01;33m\]]\[\e[00m\]\$ '\'' ; \
        eval `dircolors -b` ; \
        alias ls="ls --color=auto" ; \
        alias l="ls -lah" ; \
        alias ll="ls -lh" ; \
    ' >> /etc/bash.bashrc && \
    ln -sf vim /usr/bin/vi

CMD ["bash", "--rcfile", "/etc/bash.bashrc"]
