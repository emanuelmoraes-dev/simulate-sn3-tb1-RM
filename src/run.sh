#!/bin/bash

# Script responsável por realizar uma simulação de rede no simulador ns3.
# A simulação consiste em um mundo ideal, onde dois nós irão se comunicar sem interferência.
# Serão realizados um conjunto de simulações variando a distãncia (steps) entre os nós.
# Para cada distãncia será variado o tamanho do pacote (pkgsizes).
# Para cada tamanho de pacote será variado o intervalo de envio de cada pacote (breaks).
#
# Após o término da simulação será gerado gráficos estatisticos sobre a simulação
#
# ATENÇÃO:
#     Para que este Script funcione é necessário que na mesma pasta esteja presente o Script"
#         mesh-2018.cc, o Script parameter-helper.sh e o Script simulate.sh"
#     Para que este Script funcione é necessário que este Script esteja dentro da pasta 'scratch' do
#         diretório de instalação do ns3
#     Para que este Script funcione é necessário executar este Script de dentro do diretório de
#         instalação do ns3
#
# Script gerado para trabalho da disciplina de Redes Móveis
#
# O Script mesh-2018.cc foi desenvolvido pela Carina Teixeira de Oliveira (email: carina@lar.ifce.edu.br)
#
# Autor: Emanuel Moraes de Almeida
# Email: emanuelmoraes297@gmail.com
# github: github.com/emanuelmoraes-dev
#
# Código de licença MIT. Faça bom uso :)
#

# Dando permição de execução para os scripts simulate.sh e plot-data.sh
chmod +x ./scratch/parameter-helper.sh
chmod +x ./scratch/simulate.sh
chmod +x ./scratch/plot-data.sh

# Simulação do NS3
./scratch/simulate.sh

if [ "$?" != "0" ]; then
    >&1 echo "Erro na Simulação!"
    exit $?
fi

# Geração de gráficos pelo gnuplot com os dados da simulação
./scratch/plot-data.sh

