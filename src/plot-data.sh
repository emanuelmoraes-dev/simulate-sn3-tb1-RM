#!/bin/bash
# Autor deste Script: Emanuel Moraes de Almeida
# Email: emanuelmoraes297@gmail.com
# github: github.com/emanuelmoraes-dev

seq80_112="`seq 80 4 112`" # Sequencia numérica de 80 a 112 de incremento de 4
seq80_112="`echo $seq80_112`" # Sequencia sem quebra de linha

# Função de ajuda: Exibe mensagem de ajuda sobre o uso do Script
function helpout {
    echo
    echo "    Script responsável por ler os resultados da simulação e gerar os arquivos .plot e .txt utilizados pelo gnuplot"
    echo
    echo "    ATENÇÃO:"
    echo "        Este Script necessita da dependência 'gnuplot' instalada"
    echo "        TODOS os parâmetros são obrigatórios"
    echo "        Para que este Script funcione é necessário que na mesma paste estaja presente o Script mesh-2018.cc e o Script parameter-helper.sh."
    echo "        Para que este Script funcione é necessário que este Script esteja dentro da de scratch do diretório de instalação do ns3"
    echo "        Para que este Script funcione é necessário executar este Script de dentro do diretório de instalação do ns3"
    echo
    echo "    Parâmetros:"
    echo "        --steps <distâncias> : Define as distâncias entre os dois nós usados na simulação em metros."
    echo "        --pkgsizes <tamanhos>: Define os tamanhos de pacotes usados na simulação."
    echo "        --breaks <intervalos>: Define os intervalos de envio usados na simulação em milissegundos."
    echo "        --outdir <diretório de saída>: Define o diretório onde os resultados da simualção foram colocados."
    echo "        --count-samples <número de amostras>: Define a quantidade de amostras em cada simulação para retirar as médias."
    echo "        --colors <cores de cada linha do gráfico>: Cada linha do gráfico representa um intervalo contido em '--breaks'"
    echo
    echo "    Exemplo Completo de Uso do Script:"
    echo "    ./scratch/plot-data.sh --steps 10 40 80 $seq80_112 --pkgsizes 64 128 512 1024 --breaks 100 10 1 --outdir $HOME/simulate-ns3-out --count-samples 30 --colors blue black red"
    echo
    echo "    Autor deste Script: Emanuel Moraes de Almeida"
    echo "    Email de Contato: emanuelmoraes297@gmail.com"
    echo "    github: github.com/emanuelmoraes-dev"
    echo
    echo "    Software com licença MIT. Faça bom uso :)"
    echo
}

# Função de ajuda: Exibe mensagem de ajuda sobre o uso do Script ao dar erro
function helperr {
    >&2 echo
    >&2 echo "    ATENÇÃO:"
    >&2 echo "        Este Script necessita da dependência 'gnuplot' instalada"
    >&2 echo "        TODOS os parâmetros são obrigatórios"
    >&2 echo "        Para que este Script funcione é necessário que na mesma paste estaja presente o Script mesh-2018.cc e o Script parameter-helper.sh."
    >&2 echo "        Para que este Script funcione é necessário que este Script esteja dentro da de scratch do diretório de instalação do ns3"
    >&2 echo "        Para que este Script funcione é necessário executar este Script de dentro do diretório de instalação do ns3"
    >&2 echo
    >&2 echo "    Parâmetros:"
    >&2 echo "        --steps <distâncias> : Define as distâncias entre os dois nós usados na simulação em metros."
    >&2 echo "        --pkgsizes <tamanhos>: Define os tamanhos de pacotes usados na simulação."
    >&2 echo "        --breaks <intervalos>: Define os intervalos de envio usados na simulação em milissegundos."
    >&2 echo "        --outdir <diretório de saída>: Define o diretório onde os resultados da simulação foram colocados."
    >&2 echo "        --count-samples <número de amostras>: Define a quantidade de amostras em cada simulação para retirar as médias."
    >&2 echo "        --colors <cores de cada linha do gráfico>: Cada linha do gráfico representa um intervalo contido em '--breaks'"
    >&2 echo
    >&2 echo "    Exemplo Completo de Uso do Script:"
    >&2 echo "    ./scratch/plot-data.sh --steps 10 40 80 $seq80_112 --pkgsizes 64 128 512 1024 --breaks 100 10 1 --outdir $HOME/simulate-ns3-out --count-samples 30 --colors blue red black"
    >&2 echo
}

# Verificando existência da dependência 'gnuplot'
echo "Verificando existência da dependência 'gnuplot'..."

if ! which gnuplot 1> /dev/null 2> /dev/null; then
    >&2 echo "Erro! gnuplot não encontrado"
    exit 127
fi

# Declarando parâmetros
echo "Declarando parâmetros..."

export steps=() # Distâncias a serem testadas
export pkgsizes=() # Tamanho dos pacotes a serem testados
export breaks=() # Intevalos de envio de pacotes
export colors=() # Cores de cada linha do gráfico
export outdir="" # Diretório onde os resultados da simulação foram colocados
export countsamples="" # Quantidade de amostras testadas para pegar media
export args=("$@") # Parâmetros do usuário

# Retorna a maior distância
function maxstep {
    max="${steps[0]}"
    len="${#steps[@]}"

    for ((i=1 ; i < len ; i++)); do
        step="${steps[i]}"
        if [ "$step" -gt "$max" ]; then
            max="$step"
        fi
    done

    echo $max
}

# Verificando se parâmetros da simulação são vazios
function verifyValuesParams {
    echo "Definindo parâmetros padrão da simulação caso estejam vazios..."
    if [ "${#steps[@]}" = "0" ]; then # Se 'steps' for um array vazio
        helperr # Executa função de ajuda
        >&2 echo "Erro! argumento '--steps' obrigatório" # Exibe mensagem de erro
        exit 2 # Script finalizado com erro
    fi

    if [ "${#pkgsizes[@]}" = "0" ]; then # Se 'pkgsizes' for um array vazio
        helperr # Executa função de ajuda
        >&2 echo "Erro! argumento '--pkgsizes' obrigatório" # Exibe mensagem de erro
        exit 2 # Script finalizado com erro
    fi

    if [ "${#breaks[@]}" = "0" ]; then # Se 'break' for um array vazio
        helperr # Executa função de ajuda
        >&2 echo "Erro! argumento '--breaks' obrigatório" # Exibe mensagem de erro
        exit 2 # Script finalizado com erro
    fi

    if [ "${#colors[@]}" = "0" ]; then
        helperr # Executa função de ajuda
        >&2 echo "Erro! argumento '--colors' obrigatório" # Exibe mensagem de erro
        exit 2 # Script finalizado com erro
    fi

    if [ -z "$outdir" ]; then # Se 'outdir' for uma string vazia
        helperr # Executa função de ajuda
        >&2 echo "Erro! argumento 'outdir' obrigatório"
        exit 2 # Script finalizado com erro
    fi

    if [ -z "$countsamples" ]; then # Se 'countsamples' for uma string vazia
        helperr # Executa função de ajuda
        >&2 echo "Erro! argumento '--count-samples' obrigatório" # Exibe mensagem de erro
        exit 2 # Script finalizado com erro
    fi

    echo "    Gerando dados de plotagem da simulação de com as distâncias ${steps[@]}, "
    echo "    com variação de tamanhos de pacote de ${pkgsizes[@]} "
    echo "    com variação de intervalos de ${breaks[@]} "
    echo "    e com quantidade de amostras por simulação igual a $countsamples"
}

# Gera arquivo .txt contendo os dados da plotagem do gráfico
# --folder-name = Nome da pasta por onde o arquivo .txt que será gerado
# --filename = Nome do arquivo .txt que será gerado
# --x-values = valores do eixo x
# --y-values = valores do eixo y
function generateTxtData {
    IFS=$'\n'
    foldername="`./scratch/parameter-helper.sh -index 0 -args folder-name filename x-values y-values \"$@\"`"
    filename="`./scratch/parameter-helper.sh -index 1 -args folder-name filename x-values y-values \"$@\"`"
    xvalues=(`./scratch/parameter-helper.sh -index 2 -args folder-name filename x-values y-values "$@"`)
    yvalues=(`./scratch/parameter-helper.sh -index 3 -args folder-name filename x-values y-values "$@"`)
    IFS=' '

    plotfolder="$outdir/$foldername" # Path da pasta de plotagem
    txt="$plotfolder/$filename.txt" # Path do arquivo .txt
    mkdir -p $plotfolder # Gerando pasta de plotagem

    # Preparando arquivo txt dos dados da função
    echo "Preparando arquivo txt dos dados da plotagem..."

    len=${#xvalues[@]} # Quantidade de valores do eixo x

    for ((i = 0; i < len ; i++)); do
        x=${xvalues[i]} # Valor do eixo x
        y=${yvalues[i]} # Valor do eixo y

        echo "$x $y" >> $txt # Joga valor x e valor y no arquivo txt
    done
}

# Gera gráfico usando gnuplot
# --folder-name = Nome da pasta do arquivo que sera gerado
# --filename = Nome do arquivo que será gerado
# --x-range = Intervalo de plotagem de x. Ex: 0:100
# --y-range = Intervalo de plotagem de y. Ex: 0:100
# --x-label = Nome da label exibida em x
# --y-label = Nome da label exibida em y
# --txt-data = Nomes dos arquivos txt contendo os dados de plotagem
# --titles = Nomes das legendas de cada linha
function generatePlot {
    IFS=$'\n'
    foldername="`./scratch/parameter-helper.sh -index 0 -args folder-name filename x-range y-range x-label y-label txt-data titles \"$@\"`"
    filename="`./scratch/parameter-helper.sh -index 1 -args folder-name filename x-range y-range x-label y-label txt-data titles \"$@\"`"
    xrange="`./scratch/parameter-helper.sh -index 2 -args folder-name filename x-range y-range x-label y-label txt-data titles \"$@\"`"
    yrange="`./scratch/parameter-helper.sh -index 3 -args folder-name filename x-range y-range x-label y-label txt-data titles \"$@\"`"
    xlabel="`./scratch/parameter-helper.sh -index 4 -args folder-name filename x-range y-range x-label y-label txt-data titles \"$@\"`"
    ylabel="`./scratch/parameter-helper.sh -index 5 -args folder-name filename x-range y-range x-label y-label txt-data titles \"$@\"`"
    txtdata=(`./scratch/parameter-helper.sh -index 6 -args folder-name filename x-range y-range x-label y-label txt-data titles "$@"`)
    titles=(`./scratch/parameter-helper.sh -index 7 -args folder-name filename x-range y-range x-label y-label txt-data titles "$@"`)
    IFS=' '

    # Preparando plotagem
    echo "Preparando plotagem..."

    plotfolder="$outdir/$foldername" # Path da pasta de plotagem
    plot="$plotfolder/$filename.plot" # Path do arquivo .plot
    pdf="$plotfolder/$filename.pdf" # Path do arquivo.pdf
    mkdir -p $plotfolder # Gerando pasta de plotagem

    # Gerando arquivo .plot
    echo "Gerando arquivo $plot ..."

    echo "set key left bottom" > $plot
    echo "set xrange[$xrange]" >> $plot
    echo "set yrange[$yrange]" >> $plot
    echo "set terminal pdf" >> $plot
    echo "set output '$pdf'" >> $plot
    echo "set xlabel \"$xlabel\"" >> $plot
    echo "set ylabel \"$ylabel\"" >> $plot
    echo "set style line 1 lw 2 pt 1 lc 1" >> $plot
    echo "set style line 2 lw 2 pt 2 lc 2" >> $plot
    echo "set style line 3 lw 2 pt 3 lc 3" >> $plot
    echo "set style line 4 lw 2 pt 4 lc 4" >> $plot

    plotdata=""

    len=${#txtdata[@]}
    for ((i=0 ; i < len; i++)); do
        txt="${txtdata[i]}"
        title="${titles[i]}"
        color="${colors[i]}"
        if [ "$i" = "0" ]; then
            plotdata="\"$txt.txt\" title '$title' lw 3 pt $(($i+1)) lt rgb '$color' with yerrorlines"
        else
            plotdata="$plotdata, \"$txt.txt\" title '$title' lw 3 pt $(($i+1)) lt rgb '$color' with yerrorlines"
        fi
    done

    echo "plot $plotdata" >> $plot

    echo "Gerando gráfico..."

    gnuplot $plot
}

# Função Principal
function main {
    echo "Preparando ambiente de geração de arquivos de plotagem..."

    # Se o primeiro argumento do usuário for --help
    if [ "${args[0]}" = "--help" ]; then
        helpout # Executa função de ajuda
        exit 0 # Finaliza Script com Sucesso
    fi

    IFS=$'\n'
    steps=(`./scratch/parameter-helper.sh -index 0 -args steps pkgsizes breaks outdir count-samples colors "${args[@]}"`)
    pkgsizes=(`./scratch/parameter-helper.sh -index 1 -args steps pkgsizes breaks outdir count-samples colors "${args[@]}"`)
    breaks=(`./scratch/parameter-helper.sh -index 2 -args steps pkgsizes breaks outdir count-samples colors "${args[@]}"`)
    outdir="`./scratch/parameter-helper.sh -index 3 -args steps pkgsizes breaks outdir count-samples colors \"${args[@]}\"`"
    countsamples="`./scratch/parameter-helper.sh -index 4 -args steps pkgsizes breaks outdir count-samples colors \"${args[@]}\"`"
    colors=(`./scratch/parameter-helper.sh -index 5 -args steps pkgsizes breaks outdir count-samples colors "${args[@]}"`)
    IFS=' '
    
    verifyValuesParams # Verificando se parâmetros da simulação são vazios

    # Iniciando extração dos dados...
    echo "Iniciando extração dos dados..."
    echo
    
    for pkgsize in "${pkgsizes[@]}"; do # A cada iteração um gráfico novo
        echo "Gerando novo gráfico com pacote de tamanho $pkgsize..."

        titles=() # Array de títulos das legendas
        txtdata=() # Array contendo os nomes dos arquivos que contem os dados de plotagem

        for interval in "${breaks[@]}"; do # A cada iteração uma linha nova no gráfico
            echo "Gerando nova linha do gráfico representando o intervalo de envio $interval..."

            len_txtdata="${#txtdata[@]}" # Tamanho do array 'txtdata'
            txtdata[$len_txtdata]="$outdir/plot/pkgsize-$pkgsize/graphic-interval-$interval" # Nome do arquivo que contem os dados da plotagem

            echo "Gerando arquivo txt do intervalo $interval..."

            inter="`echo \"scale=3 ; $interval/1000\" | bc`" # Intervalo transformado de milissegundo para segundo

            len_titles="${#titles[@]}"
            titles[$len_titles]="Intervalo de Envio de $inter segundos"

            xvalues=() # Valores do eixo x
            yvalues=() # Valores do eixo y

            for step in "${steps[@]}"; do # A cada iteração uma distãncia (valor do eixo x) nova
                echo "Anexando distância $step no eixo x..."

                len_xvalues="${#xvalues[@]}" # Tamanho do array 'xvalues'
                xvalues[$len_xvalues]="$step" # A distãncia é o novo valor do eixo x

                echo "Calculando taxa de entrega média dentre as $countsamples amostras..."

                echo "Avaliando amostra 1..."

                y_average="`cat $outdir/out/simulate-$step-$pkgsize-$interval-1/log | grep "DeliveryRate" | awk '{print $2}'`"

                if [ -z "$y_average" ]; then
                    y_average=0
                fi

                echo "Taxa de entrega da amostra 1 = $y_average"

                for ((count=2 ; count <= countsamples ; count++)); do
                    echo "Avaliando amostra $count..."

                    # Obtém o valor da taxa de entrega desta simulação
                    y="`cat $outdir/out/simulate-$step-$pkgsize-$interval-$count/log | grep "DeliveryRate" | awk '{print $2}'`"

                    if [ -z "$y" ]; then
                        y=0
                    fi

                    echo "Taxa de entrega da amostra $count = $y"

                    y_average="`echo \"scale=4 ; $y_average+$y\" | bc`" # Acumula o valor da taxa de entraga na variável 'y_average'
                done

                echo "Calculando média das taxas de entrega ($y_average/$countsamples)..."

                y_average="`echo \"scale=4 ; $y_average/$countsamples\" | bc`" # Obtém a média de todas as taxas de entrega

                echo "Média das taxas de entrega = $y_average"
                echo "Anexando média das taxas de entrega das $countsamples amostras..."

                len_yvalues="${#yvalues[@]}" # Tamanho do array 'y_values'
                yvalues[$len_yvalues]="$y_average" # A média de todas as taxas de entrega é o novo valor para o eixo y
            done

            echo "Gerando arquivo txt com dos dados dos eixos x e y..."

            # Gera arquivo txt novo para cada linha
            generateTxtData --folder-name "plot/pkgsize-$pkgsize" --filename "graphic-interval-$interval" \
                --x-values "${xvalues[@]}" --y-values "${yvalues[@]}"
        done

        echo "Gerando gráfico '$outdir/plot/pkgsize-$pkgsize/graphic-pkgsize-$pkgsize.pdf' com os dados coletados..."

        # Gera um novo gráfico
        generatePlot --folder-name "plot/pkgsize-$pkgsize" --filename "graphic-pkgsize-$pkgsize" --x-range "0:`maxstep`" \
            --y-range "0:110" --x-label "Distância" --y-label "Taxa de Entrega" --txt-data "${txtdata[@]}" \
            --titles "${titles[@]}"
    done

    echo
	echo "Graficos Gerados com Sucesso!"
}

main # Executa função principal

