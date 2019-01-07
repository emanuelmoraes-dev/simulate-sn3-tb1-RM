Script responsável por realizar uma simulação de rede no simulador ns3.
A simulação consiste em um mundo ideal, onde dois nós irão se comunicar sem interferência.
Serão realizados um conjunto de simulações variando a distãncia (steps) entre os nós.
Para cada distãncia será variado o tamanho do pacote (pkgsizes).
Para cada tamanho de pacote será variado o intervalo de envio de cada pacote (breaks).

Após o término da simulação será gerado gráficos estatisticos sobre a simulação

ATENÇÃO:
    Para que este Script funcione é necessário que na mesma pasta esteja presente o Script
        mesh-2018.cc, o Script parameter-helper.sh e o Script simulate.sh
    Para que este Script funcione é necessário que este Script esteja dentro da pasta 'scratch' do
        diretório de instalação do ns3
    Para que este Script funcione é necessário executar este Script de dentro do diretório de
        instalação do ns3

Script gerado para trabalho da disciplina de Redes Móveis

O Script mesh-2018.cc foi desenvolvido pela Carina Teixeira de Oliveira (email: carina@lar.ifce.edu.br)
