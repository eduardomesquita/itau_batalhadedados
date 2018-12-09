install.packages( "devtools" , repos = "http://cran.rstudio.com/" )
library(devtools)
install_github( "ajdamico/lodown" , dependencies = TRUE )

install.packages( "convey" , repos = "http://cran.rstudio.com/" )
install.packages( "srvyr" , repos = "http://cran.rstudio.com/" )

library(lodown)

######
setwd("/Users/andreluna/Downloads/")

pnad <- read.table("PNADC_042017_20180816.txt")
library(PNADcIBGE)
dadosPNADc = get_pnadc(year = 2017, quarter = 3)

library(readtext)
table  <- read.table("Escolas_tabela2.csv", header = T, sep = ";")
names(table$x1) <- "Municipio"

#lendo tabelas tratadas
tratados_2015 <- read.table("inep_2015_trat.csv", sep = ",", header = T)
tratados_2015$ano <- 2015
tratados_2015$n_matriculados <- 1
tratados_2015$tp_sexo <- ifelse(tratados_2015$tp_sexo == 1, 1, 0)

tratados_2015 <- dummy_cols(tratados_2015, c("tp_cor_raca", "deficiencia"))
tratados_2015 <- tratados_2015 %>% filter(tratados_2015$matriula.co_municipio == 3550308)

group_2015 <- tratados_2015 %>% group_by(escolas.co_entidade) %>% summarize(idade_media = mean(nu_idade_referencia),
                                                duracao_media = mean(nu_duracao_turma),
                                                prop_masculino = mean(tp_sexo),
                                                prop_etnia_nd = mean(tp_cor_raca_0),
                                                prop_etnia_branco = mean(tp_cor_raca_1),
                                                prop_etnia_negro = mean(tp_cor_raca_2),
                                                prop_etnia_pardo = mean(tp_cor_raca_3),
                                                prop_etnia_amarelo = mean(tp_cor_raca_4),
                                                prop_etnia_indigena = mean(tp_cor_raca_5),
                                                prop_deficiencia = mean(deficiencia_S),
                                                media_comp = mean(nu_comp_aluno),
                                                prop_alimentacao = mean(in_alimentacao),
                                                ano = max(ano),
                                                total_matriculados = sum(n_matriculados))

tratados_2016 <- read.table("inep_2016_trat.csv", sep = ",", header = T)
tratados_2016$ano <- 2016

tratados_2016$n_matriculados <- 1
tratados_2016$tp_sexo <- ifelse(tratados_2016$tp_sexo == 1, 1, 0)

tratados_2016 <- dummy_cols(tratados_2016, c("tp_cor_raca", "deficiencia"))
tratados_2016 <- tratados_2016 %>% filter(tratados_2016$matriula.co_municipio == 3550308)

group_2016 <- tratados_2016 %>% group_by(escolas.co_entidade) %>% summarize(idade_media = mean(nu_idade_referencia),
                                                                                       duracao_media = mean(nu_duracao_turma),
                                                                                       prop_masculino = mean(tp_sexo),
                                                                                       prop_etnia_nd = mean(tp_cor_raca_0),
                                                                                       prop_etnia_branco = mean(tp_cor_raca_1),
                                                                                       prop_etnia_negro = mean(tp_cor_raca_2),
                                                                                       prop_etnia_pardo = mean(tp_cor_raca_3),
                                                                                       prop_etnia_amarelo = mean(tp_cor_raca_4),
                                                                                       prop_etnia_indigena = mean(tp_cor_raca_5),
                                                                                       prop_deficiencia = mean(deficiencia_S),
                                                                                       media_comp = mean(nu_comp_aluno),
                                                                                       prop_alimentacao = mean(in_alimentacao),
                                                                                       ano = max(ano),
                                                                                       total_matriculados = sum(n_matriculados))



tratados_2017 <- read.table("inep_2017_trat.csv", sep = ",", header = T)
tratados_2017$ano <- 2017

tratados_2017$n_matriculados <- 1
tratados_2017$tp_sexo <- ifelse(tratados_2015$tp_sexo == 1, 1, 0)

tratados_2017 <- dummy_cols(tratados_2017, c("tp_cor_raca", "deficiencia"))
tratados_2017 <- tratados_2017 %>% filter(tratados_2015$matriula.co_municipio == 3550308)

group_2017 <- tratados_2017 %>% group_by(escolas.co_entidade) %>% summarize(idade_media = mean(nu_idade_referencia),
                                                                                       duracao_media = mean(nu_duracao_turma),
                                                                                       prop_masculino = mean(tp_sexo),
                                                                                       prop_etnia_nd = mean(tp_cor_raca_0),
                                                                                       prop_etnia_branco = mean(tp_cor_raca_1),
                                                                                       prop_etnia_negro = mean(tp_cor_raca_2),
                                                                                       prop_etnia_pardo = mean(tp_cor_raca_3),
                                                                                       prop_etnia_amarelo = mean(tp_cor_raca_4),
                                                                                       prop_etnia_indigena = mean(tp_cor_raca_5),
                                                                                       prop_deficiencia = mean(deficiencia_S),
                                                                                       media_comp = mean(nu_comp_aluno),
                                                                                       prop_alimentacao = mean(in_alimentacao),
                                                                                       ano = max(ano),
                                                                                       total_matriculados = sum(n_matriculados))

tratados_append <- rbind(group_2015, group_2016, group_2017)


#plugando codigo ibge
step1 <- tratados_append %>% filter(ano == 2015) %>% mutate( matricul2015 = total_matriculados)
step2 <- tratados_append %>% filter(ano == 2016) %>% mutate( matricul2016 = total_matriculados)
step3 <- tratados_append %>% filter(ano == 2017) %>% mutate( matricul2017 = total_matriculados)

taxa_evasao_2016 <- step2 %>% select(escolas.co_entidade, matricul2016) %>% 
                        merge(step2, step1, by.x = "escolas.co_entidade", by.y = "escolas.co_entidade") #%>%
                          mutate(taxa_evasao = -(matricul2016 - matricul2015)/matricul2016)
                          
taxa_evasao_2017 <- step3 %>% select(escolas.co_entidade, matricul2017) %>% 
                      merge(step3, step2, by.x = "escolas.co_entidade", by.y = "escolas.co_entidade") #%>%
                        mutate(taxa_evasao = -(matricul2017 - matricul2016)/matricul2017)
                        
                          
tratados_append <- tratados_append %>% merge(taxa_evasao_2016, by.x = "escolas.co_entidade", by.y = "escolas.co_entidade") %>%
                          mutate(taxa_evasao_2016 = ifelse(ano == 2016, taxa_evasao, 0))

tratados_append <- tratados_append %>% merge(taxa_evasao_2017, by.x = "escolas.co_entidade", by.y = "escolas.co_entidade") %>%
  mutate(taxa_evasao_2017 = ifelse(ano == 2017, taxa_evasao, 0))

write.table(tratados_append, "tabela_final.csv", dec = ",")
