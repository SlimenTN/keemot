

const book = {
    "coming.stuff": <String>[
      "Coming Staff To Do",
      "Prochaine tâches à faire"
    ],
    "no.stuff.to.do": <String>[
      "You are free for the next 7 days",
      "Vous n'avez rien à faire pour les 7 prochains jours"
    ],
    "list.repeated.tasks": <String>[
      "List of repeated tasks",
      "Liste des tâches à faire"
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
    "reiteration.each": <String>[
      "Reiteration: Each",
      "Répétition: Chaque"
    ],
    "remind.me.before": <String>[
      "Remind me before",
      "Rappeler moi avant"
    ],
    "reminder.before": <String>[
      "Reminder: Before",
      "Rappel: Avant"
    ],
    "new.stuff": <String>[
      "New Task",
      "Nouvelle Tâche"
    ],
    "long.press.to.edit.this.task": <String>[
      "Long press to edit this task",
      "Appuyez longuement pour modifier cette tâche"
    ],
    "english": <String>[
      "English",
      "Anglais"
    ],
    "french": <String>[
      "French",
      "Français"
    ],
    "select.your.language": <String>[
      "Select your language",
      "Sélectionez votre langue"
    ],
    "save": <String>[
      "Save",
      "Enregistrer"
    ],
    "cancel": <String>[
      "Cancel",
      "Annuler"
    ],
    "form.invalid.title": <String>[
      "Form invalid!",
      "Formulaire invalide!"
    ],
    "form.invalid.description": <String>[
      "Please make sure to fill all the requested data.",
      "S'il vous plaît assurez-vous de remplir toutes les données demandées."
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

  if(book[word] == null)
    return word;
  else
    return book[word][index];
}