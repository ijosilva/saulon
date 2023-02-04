% Lê o arquivo CSV
pkg load signal
data = dlmread("CovidNumerico.csv", ",", 1, 0); % inclui a opção "," para especificar o separador de colunas

% Lê o título das colunas do arquivo
fid = fopen("CovidNumerico.csv");
titulos = strsplit(fgetl(fid), ","); % separa as colunas pelo separador ","
fclose(fid);

% Pergunta ao usuário quantas vezes o filtro deve ser aplicado
passadas = input("Quantas vezes deseja aplicar o filtro de Savitsky-Golay? ");

%  A coluna que deseja filtrar - Casos novos
coluna = 3;

% Aplicando o filtro de Savitsky-Golay
largura = 3;
ordem_polinomio = 1;
if mod(largura, 2) == 0 % verifica se o tamanho do filtro é ímpar
    largura = largura + 1; % se não for, aumenta em 1 para torná-lo ímpar
end
filtrado = sgolayfilt(data(:,coluna), ordem_polinomio, largura);
for i=1:passadas-1
    filtrado = sgolayfilt(filtrado, ordem_polinomio, largura);
end

% Plotagem dos dados originais e dos dados filtrados
figure;
plot(data(:,coluna), "b", "LineWidth", 2, "DisplayName", sprintf("Dados originais - %s", titulos{coluna}));
hold on;
plot(filtrado, "r", "LineWidth", 2, "DisplayName", sprintf("Dados filtrados - %s", titulos{coluna}));
legend("show");
xlabel("Tempo");
ylabel("Valor");
title(sprintf("Filtro de Savitsky-Golay aplicado %d vezes na coluna %s", passadas, titulos{coluna}));
