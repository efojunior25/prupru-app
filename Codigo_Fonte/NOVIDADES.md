## Correções

- **Nome de usuário com espaço**: as ferramentas (Otimizador, Limpeza, Diagnóstico e as demais) agora pedem permissão de administrador normalmente em computadores cujo usuário tem espaço no nome (ex.: `C:\Users\Maria Silva`). Antes, elas fechavam sem rodar.
- **Atualização automática em pastas com acento**: o atualizador foi refeito e funciona em usuários com acento no nome (ex.: `C:\Users\João`). Ele espera o PruPru fechar, guarda a versão anterior e, se algo der errado na troca, devolve o arquivo antigo e avisa na tela.
- **Idioma das ferramentas**: com o Windows em inglês ou espanhol, as ferramentas agora abrem no mesmo idioma do painel. Antes, algumas abriam em português.

## Como atualizar

Quem já tem o PruPru.exe recebe a atualização automaticamente na próxima verificação. Se o seu usuário do Windows tem acento no nome e a atualização não concluir, baixe a versão nova uma única vez em [prupru.org/download](https://prupru.org/download). Daí em diante, as atualizações funcionam normalmente.

## Observação de segurança

Nenhuma ferramenta nova foi adicionada e nenhuma ação das ferramentas mudou. As correções mexem só na forma de pedir permissão de administrador, no processo de atualização e no arquivo de idioma.
