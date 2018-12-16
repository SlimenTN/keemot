

const book = {
    "app.title": <String>[
      "Keemot",
      "Keemot"
    ],
    "coming.stuff": <String>[
      "Coming Staff To Do",
      "Prochaine tâches à faire"
    ],
    "list.repeated.tasks": <String>[
      "List of repeated tasks",
      "Liste des tâche à faire"
    ],
    "MONTH": <String>[
      "Month",
      "Mois"
    ],
    "YEAR": <String>[
      "Year",
      "Année"
    ],
    "DAY": <String>[
      "Day",
      "Jour"
    ],
    "WEEK": <String>[
      "Week",
      "Semaine"
    ],
    "start.date": <String>[
      "Start date",
      "Date de début"
    ],
    "reiteration": <String>[
      "Reiteration",
      "Répétition"
    ],
    "reminder": <String>[
      "Reminder",
      "Rappel"
    ],
    "what.should.I.remind.you.with": <String>[
      "What should I remind you with",
      "Que dois-je te rappeler avec"
    ],
    "ex.pay.some.bills": <String>[
      "ex: Pay some bills",
      "ex: Payer des factures"
    ],
    "select.date": <String>[
      "Salect a Date",
      "Sélectionnez une date"
    ],
    "select.time": <String>[
      "Salect a Time",
      "Sélectionnez une heure"
    ],
    "reiteration.every": <String>[
      "Reiteration every",
      "Répétition chaque"
    ],
    "remind.me.before": <String>[
      "Remind me before",
      "Rappeler moi avant"
    ],
};

String lang;

// Translate the selected word
String translate(String word){
  int index;
  switch(lang){
    case 'en':
      index = 0;
      break;
    case 'fr':
      index = 1;
      break;
  }
  return book[word][index];
}