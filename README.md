## Descrição
Scripts responsáveis pela realização de uma simulação de rede no simulador ns3.
Tal simulação consiste na medição da taxa de entrega pela variação da
distância entre dois nós. Foram gerados 4 gráficos de linhas apresentando a
taxa de entrega média de 30 amostras por simulação pela alteração dos 
tamanhos dos pacotes, do intervalo de envio e da distância dos dois nós.
A simulação consiste em um mundo ideal, onde dois nós se comunicaram sem interferência.
Foram realizados um conjunto de simulações variando a distãncia (steps) entre os nós.
Para cada distância variou-se o tamanho do pacote (pkgsizes).
Para cada tamanho de pacote variou-se o intervalo de envio de cada pacote (breaks).

Após o término da simulação foram gerados gráficos estatisticos sobre a simulação.

### ATENÇÃO:
* Para a execução da simulação apenas os arquivos da pasta 'src' tornam-se necessários;
* Todos os parâmetros da simulaçao podem ser alterados para quaisquer valores desejados no arquivo 'src/run.sh';
* Para obter ajuda sobre os parâmetros da simulação e sobre o funcionamento dos scripts, execute o script 'src/simulate.sh' com o parâmetro '--help'
* Para que este projeto seja executado, é nessário que o conteúdo da pasta 'src' seja copiado para a pasta 'scratch' presente no diterório de instalação do NS3;
* Para que este projeto seja executado é necessário executar o script 'run.sh' de dentro da pasta de instalação do ns3 que contem o arquivo 'waf';
* As pastas 'out', 'plot' e 'xmls' contem respectivamente os dados de saída do script 'mesh-2018.cc', os dados de plotagem e as estatisticas de cada simulação realizada na simulação teste previsamente feita.
* Cada pasta contida dentro da pasta 'out' e 'xmls' contem resultados de uma simulação. Cada número contido no nome na pasta representa, respectivamente a distância (em metros), o tamanho do pacote (em bytes), o intervalo de envio de pacotes (em milissegundos) e o número da amostra.

Script gerado para trabalho da disciplina de Redes Móveis no Instituto Federal de Educação, Ciência e Tecnologia do Ceará.

O Script mesh-2018.cc foi desenvolvido pela Carina Teixeira de Oliveira (email: carina@lar.ifce.edu.br).
