library(rvest)
library(tidyverse)
library(janitor)

team_abbrevs=read_csv("Team Abbrev.csv") %>% filter(season>=1985 & team !="League Average") %>% 
  filter(!(season == 1987 & abbreviation %in% c("GSW","LAC","LAL","MIL","POR","SAC","SEA"))) %>%
  filter(!(season == 1990 & abbreviation %in% c("IND","MIN","ORL")))
salaries=tibble(season=integer(),team=character(),player=character(),salary=double())
for (i in seq(nrow(team_abbrevs))){
  bref_url=paste0("https://www.basketball-reference.com/teams/",
                  team_abbrevs$abbreviation[i],"/",
                  team_abbrevs$season[i],".html")
  new_season=bref_url %>% read_html %>% html_nodes(xpath = '//comment()') %>%
    html_text() %>% paste(collapse='') %>% read_html() %>% 
    html_nodes(xpath=paste0('//*[(@id = "div_salaries2")]')) %>% 
    html_nodes("table") %>% .[[1]] %>% html_table()
  colnames(new_season)=c("Rk","player","salary")
  new_season=new_season %>% mutate(salary=parse_number(salary)) %>% select(-Rk) %>% 
    mutate(tm=team_abbrevs$abbreviation[i],season=team_abbrevs$season[i])
  salaries=rbind(salaries,new_season)
}
salaries=salaries %>% mutate(source="Basketball-Reference")
write_csv(salaries,"Player Salaries.csv")

#edit players to match rest of bb-ref site

# Aleksandar Radojević, Álex Abrines, Alexis Ajinça, Anderson Varejão, Andrés Guibert,
# Andrés Nocioni, Andris Biedriņš, Ante Žižić, Bill Walker -> Henry Walker, Boban Marjanović,
# Bogdan Bogdanović, Bojan Bogdanović, Boštjan Nachbar, Bruno Šundov, Cezary Trybański,
# Cristiano Felício, Dalibor Bagarić, Damjan Rudež, Dario Šarić, Darko Miličić, Dāvis Bertāns, Dennis Schröder,
# Dennis Smith Jr., Derrick Jones Jr., Didier Ilunga-Mbenga -> D.J. Mbenga, Donatas Motiejūnas,
# Dragan Tarlać, Dražen Petrović, Eduardo Nájera, Efthimis Rentzias, Elie Okobo, Ersan İlyasova,
# Felipe López, Francisco García, Frank Mason III, George Zídek, Gheorghe Mureșan, Goran Dragić,
# Gordan Giriček, Greivis Vásquez, Guillermo Díaz, Gundars Vētra, Gustavo Ayón, Hanno Möttölä,
# Hedo Türkoğlu, Horacio Llamas, Igor Rakočević, Ish Smith, Jakob Poeltl, Jan Veselý,
# Jeff Taylor, Jeff Sheppard, Jérôme Moïso, Jiří Welsch, Jonas Valančiūnas, Jorge Gutiérrez,
# J.J. Barea, José Calderón, José Ortiz, Joe Young, Juan Hernangómez, Jusuf Nurkić,
# Kelly Oubre Jr., Kevin Séraphin, Kiwane Lemorris Garris, Kornél Dávid, Kosta Perović,
# Kristaps Porziņģis, Lou Amundson, Lou Williams, Gigi Datome, Manu Ginóbili, Marko Jarić,
# Marko Milič, Martin Müürsepp, Martynas Andriuškevičius, Marvin Bagley III, Michael Porter Jr.,
# Mickaël Gelabale, Mickaël Piétrus, Michael Holton, Mile Ilić, Miloš Babić, Miloš Teodosić,
# Mirsad Türkcan, Mirza Teletović, Mo Bamba, Nando De Colo, Nemanja Nedović, Nenad Krstić, 
# Nenê, Nicolás Brussino, Nicolás Laprovíttola, Nikola Jokić, Nikola Jovanović, Nikola Mirotić,
# Nikola Peković, Nikola Vučević, Ognjen Kuzmić, Ömer Aşık, Orien Greene, Óscar Torres, 
# Patrick Beverley, Patty Mills, Peja Stojaković, Pepe Sánchez, Pero Antić, Pétur Guðmundsson,
# Predrag Savović, Primož Brezec, Radisav Ćurčić, Rafael Araújo, Ramón Rivas, Rasho Nesterović,
# Rastko Cvetković, Raül López, Richard Petruška, Roko Ukić, Rubén Garcés, Rubén Wolkowyski,
# Rudy Fernández, Šarūnas Jasikevičius, Šarūnas Marčiulionis, Sasha Danilović,
# Sasha Kravtsov -> Viacheslav Kravtsov, Sasha Pavlović, Sasha Vujačić, Sergio Rodríguez,
# Sheldon McClellan -> Sheldon Mac, Skal Labissière, Slavko Vraneš, Stéphane Lasme, Stojko Vranković,
# Taurean Waller-Prince -> Taurean Prince, Tibor Pleiß, Timothé Luwawu-Cabarrot, Tomáš Satoranský,
# Toni Kukoč, Troy Brown Jr., Uroš Slokar, Vítor Luiz Faverani, Vladimir Radmanović, 
# Walt Lemon Jr., Walter Tavares -> Edy Tavares, Wendell Carter Jr., Willy Hernangómez, 
# Žan Tabak, Žarko Čabarkapa, Željko Rebrača, Zoran Dragić, Zoran Planinić
