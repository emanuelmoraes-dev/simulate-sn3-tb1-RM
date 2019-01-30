#!/bin/bash
# O Script mesh-2018.cc foi desenvolvido pela Carina Teixeira de Oliveira (email: carina@lar.ifce.edu.br)
# Autor deste Script: Emanuel Moraes de Almeida
# Email: emanuelmoraes297@gmail.com
# github: github.com/emanuelmoraes-dev

seq80_112="`seq 80 4 112`" # Sequencia numérica de 80 a 112 de incremento de 4
seq80_112="`echo $seq80_112`" # Sequencia sem quebra de linha

# Função de ajuda: Exibe mensagem de ajuda sobre o uso do Script
function helpout {
    echo "    Script responsável por realizar uma simulação de rede no simulador ns3."
    echo "    A simulação consiste em um mundo ideal, onde dois nós irão se comunicar sem interferência."
    echo "    Serão realizados um conjunto de simulações variando a distãncia (steps) entre os nós."
    echo "    Para cada distãncia será variado o tamanho do pacote (pkgsizes)."
    echo "    Para cada tamanho de pacote será variado o intervalo de envio de cada pacote (breaks)."
    echo "    Este Script foi adaptado para receber quaisquer valores de parâmetros e executar a simulação."
    echo
    echo "    ATENÇÃO:"
    echo "        Para que este Script funcione é necessário que na mesma pasta esteja presente o Script"
    echo "            mesh-2018.cc e o Script parameter-helper.sh."
    echo "        Para que este Script funcione é necessário que este Script esteja dentro da de scratch do"
    echo "            diretório de instalação do ns3"
    echo "        Para que este Script funcione é necessário executar este Script de dentro do diretório de"
    echo "            instalação do ns3"
    echo
    echo "    Parâmetros:"
    echo "        --steps <distâncias> : Define as distâncias entre os dois nós usados na simulação em metros."
    echo "            Valores Padrão: --steps 10 60 65 70 75 $seq80_112"
    echo "        --pkgsizes <tamanhos>: Define os tamanhos de pacotes usados na simulação."
    echo "            Valores Padrão: --pkgsizes 64 128 512 1024"
    echo "        --breaks <intervalos>: Define os intervalos de envio usados na simulação em milissegundos."
    echo "            Valores Padrão --breaks 100 10 1"
    echo "        --outdir <diretório de saída>: Define o diretório por onde serão jogadas as estatísticas da"
    echo "            simulação. Valor Padrão --outdir $HOME/simulate-ns3-out"
    echo "        --count-samples <número de amostras>: Define a quantidade de amostras em cada simulação para."
    echo "            retirar as médias. Valor Padrão --count-samples 30"
    echo
    echo "    Exemplo Completo de Uso do Script com os Valores Padrão:"
    echo "    ./scratch/simulate.sh --steps 10 60 65 70 75 $seq80_112 --pkgsizes 64 128 512 1024 --breaks 100 10 1 --outdir $HOME/simulate-ns3-out --count-samples 30"
    echo
    echo "    Autor deste Script: Emanuel Moraes de Almeida"
    echo "    Email de Contato: emanuelmoraes297@gmail.com"
    echo "    github: github.com/emanuelmoraes-dev"
    echo
    echo "    Autora do Script 'mesh-2018.cc': Carina Teixeira de Oliveira (email: carina@lar.ifce.edu.br)"
    echo
    echo "    Software com licença MIT. Faça bom uso :)"
    echo
}

# Função de ajuda: Exibe mensagem de ajuda sobre o uso do Script ao dar erro
function helperr {
    >&2 echo
    >&2 echo "    ATENÇÃO:"
    >&2 echo "        Para que este Script funcione é necessário que na mesma paste estaja presente o Script mesh-2018.cc e o Script parameter-helper.sh."
    >&2 echo "        Para que este Script funcione é necessário que este Script esteja dentro da de scratch do diretório de instalação do ns3"
    >&2 echo "        Para que este Script funcione é necessário executar este Script de dentro do diretório de instalação do ns3"
    >&2 echo
    >&2 echo "    Parâmetros:"
    >&2 echo "        --steps <distâncias> : Define as distâncias entre os dois nós usados na simulação em metros."
    >&2 echo "            Valores Padrão: --steps 10 60 65 70 75 $seq80_112"
    >&2 echo "        --pkgsizes <tamanhos>: Define os tamanhos de pacotes usados na simulação."
    >&2 echo "            Valores Padrão: --pkgsizes 64 128 512 1024"
    >&2 echo "        --breaks <intervalos>: Define os intervalos de envio usados na simulação em milissegundos."
    >&2 echo "            Valores Padrão --breaks 100 10 1"
    >&2 echo "        --outdir <diretório de saída>: Define o diretório por onde serão jogadas as estatísticas da"
    >&2 echo "            simulação. Valor Padrão --outdir $HOME/simulate-ns3-out"
    >&2 echo "        --count-samples <número de amostras>: Define a quantidade de amostras em cada simulação para."
    >&2 echo "            retirar as médias. Valor Padrão --count-samples 30"
    >&2 echo
    >&2 echo "    Exemplo Completo de Uso do Script com os Valores Padrão:"
    >&2 echo "    ./scratch/simulate.sh --steps 10 60 65 70 75 $seq80_112 --pkgsizes 64 128 512 1024 --breaks 100 10 1 --outdir $HOME/simulate-ns3-out --count-samples 30"
    >&2 echo
}

# Declarando parâmetros
echo "Declarando parâmetros..."

export steps=() # Distâncias a serem testadas
export pkgsizes=() # Tamanho dos pacotes a serem testados
export breaks=() # Intevalos de envio de pacotes
export outdir="" # Valor do diretório por onde serão jogados as estatisticas da simulação
export countsamples="" # Valor para a quantidade de amostras em cada simulação

# Definindo parâmetros padrão da simulação caso estejam vazios
function setDefaultValues {
    echo "Definindo parâmetros padrão da simulação caso estejam vazios..."
    if [ "${#steps[@]}" = "0" ]; then # Se 'steps' for um array vazio
        steps=(10 60 65 70 75 $seq80_112) # Valores padrão das distâncias em metros
    fi

    if [ "${#pkgsizes[@]}" = "0" ]; then # Se 'pkgsizes' for um array vazio
        pkgsizes=(64 128 512 1024) # Valores padrão dos tamanhos dos pacotes em bytes
    fi

    if [ "${#breaks[@]}" = "0" ]; then # Se 'breaks' for um array vazio
        breaks=(100 10 1) # Valores padrão dos intervalos entre os pacotes em milissegundos
    fi

    if [ -z "$outdir" ]; then # Se 'outdir' for uma string vazia
        outdir="$HOME/simulate-ns3-out" # Valor padrão do diretório por onde serão jogados as estatisticas da simulação
    fi

    if [ -z "$countsamples" ]; then # Se 'countsamples' for uma string vazia
        countsamples=30 # Valor padrão para a quantidade de amostras em cada simulação
    fi

    echo "    Iniciando simulação com variação de distâncias ${steps[@]} "
    echo "    com variação de tamanhos de pacote de ${pkgsizes[@]} "
    echo "    com variação de intervalos de ${breaks[@]} "
    echo "    e com quantidade de amostras por simulação igual a $countsamples"
}

export args=("$@")

# Função Principal
function main {
    echo "Preparando ambiente de simulação..."

    # Se o primeiro argumento do usuário for --help
    if [ "${args[0]}" = "--help" ]; then
        helpout # Executa função de ajuda
        exit 0 # Finaliza Script com Sucesso
    fi

    # Modifica valores da simulação pelos argumentos passados pelo usuário
    
    IFS=$'\n'
    steps=(`./scratch/parameter-helper.sh -index 0 -args steps pkgsizes breaks outdir count-samples "${args[@]}"`)
    pkgsizes=(`./scratch/parameter-helper.sh -index 1 -args steps pkgsizes breaks outdir count-samples "${args[@]}"`)
    breaks=(`./scratch/parameter-helper.sh -index 2 -args steps pkgsizes breaks outdir count-samples "${args[@]}"`)
    outdir=(`./scratch/parameter-helper.sh -index 3 -args steps pkgsizes breaks outdir count-samples "${args[@]}"`)
    countsamples="`./scratch/parameter-helper.sh -index 4 -args steps pkgsizes breaks outdir count-samples \"${args[@]}\"`"
    IFS=' '

    setDefaultValues # Seta valores padrão para os valores da simulação caso usuário não tenha os modificados

    # Iniciando simulação
    echo "Iniciando simulação..."
    echo

    ilen=${#steps[@]}
    jlen=${#pkgsizes[@]}
    klen=${#breaks[@]}

    i=1
    for step in ${steps[@]}; do # Percorre as distâncias
        j=1
        for pkgsize in ${pkgsizes[@]}; do # Percorre os tamanhos de pacote
            k=1
            for interval in ${breaks[@]}; do # Percorre os intervalos de envio de pacotes 
                for ((count=1 ; count <= countsamples ; count++)); do

                    echo
                    echo "step = $step"
                    echo "pkgsize = $pkgsize"
                    echo "Intervalo de Envio = $interval"
                    echo "Amostra = $count"
                    echo
                    echo "step: $i/$ilen"
                    echo "pkgsize $j/$jlen"
                    echo "interval: $k/$klen"
                    echo "countsamples: $count/$countsamples"
                    echo
                    date | awk '{print $4}'
                    echo

                    # Intervalo convertido de milissegundos para segundos
                    newinterval=`echo "scale=3 ; $interval/1000" | bc`
                    # Cria diretório pra receber a saida do script mesh-2018
                    mkdir -p "$outdir/out/simulate-$step-$pkgsize-$interval-$count"
                    # Executa com o ns3 o script 'mesh-2018.cc' que realizará a simulação com os parâmetros fornecidos
                    ./waf --run "scratch/mesh-2018 --step=$step --packet-size=$pkgsize --packet-interval=$newinterval" \
                        1> "$outdir/out/simulate-$step-$pkgsize-$interval-$count/log"
                    # Cria diretório para receber os xmls resultados da simulação
                    mkdir -p "$outdir/xmls/simulate-$step-$pkgsize-$interval-$count"
                    # Move para diretório de saida os resultados da simulação
                    echo "Movendo para $outdir/xmls/simulate-$step-$pkgsize-$interval-$count os resultados da simulação..."
                    mv mp-report-0.xml mp-report-1.xml "$outdir/xmls/simulate-$step-$pkgsize-$interval-$count"
                done
                let k=k+1
            done
            let j=j+1
        done
        let i=i+1
    done

    echo
	echo "Simulação finalizada com sucesso!"
}

main # Executa função principal

