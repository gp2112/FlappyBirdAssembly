# FlappyBirdAssembly
Trabalho para a disciplina SSC0119 - Prática em Organização de Computadores (2021)

O objetivo desse trabalho é aplicar os conceitos aprendidos durante o semestre sobre o funcionamento interno de uma CPU e a forma como os comandos do software em Assembly se relacionam com o hardware da 
máquina.

## Explicações em Vídeos

[Explicação da modificação do processador](https://youtu.be/qPHO3rvlrGc)

[Explicação do jogo](https://youtu.be/-Bqx55UJdX8)

---
## Como executar?

Clone esse projeto em seu computador usando o comando:

`git clone https://github.com/gp2112/FlappyBirdAssembly.git`


Abra a pasta pelo terminal e execute para compilar o jogo.:

`./montador flappy.asm flappy.mif`


Utilize o comando abaixo para executar:

`./sim flappy.mif charmap.mif`


> Observação: o procedimento acima funciona apenas para sistemas operacionais Linux - Ubuntu, caso deseje executar em outros sistemas operacionais é necessário instalar um simulador adequado [clicando aqui.](https://github.com/simoesusp/Processador-ICMC/tree/master/Simple_Simulator)
---
## Jogo Flappy Bird

Você é um pássaro e precisa voar e desviar dos tiros! Voe usando a barra de espaço, não seja atingido, nem caia no chão!

Jogo:

![image](jogo.png)

Game Over:

![image](game_over.png)

Execução no simulador:

![imagem](execucao_terminal.png)

---
## Modificação na CPU:

Adicionado comando RAND, que, através do registrador regRand, retorna ao resgistrado (Rx) o valor "aleatório"

![image](https://github.com/gp2112/FlappyBirdAssembly/blob/main/arquitetura.png)

RAND Rx


