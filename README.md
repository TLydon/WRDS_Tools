#A tool I quickly programmed in order to associate Anonymized Hedge Funds on WRDS with their respective Identifications; although I intend to expand this repository.

#There are 4 different Hedge Fund Databases offered by WRDS.
  1. Morningstar CISDM
  2. Thomson TASS
  3. HFR
  4. and EurekaHedge

#While there exist fancier subscriptions that allow for access to Identifiers,HFR and Thomson TASS do not make this information available to everyone.
To clarify,
   All Morningstar CISDM subscriptions seem to identify every fund.
     HFR and Thomason TASS do not. As far as I know, TASS doesn't seem to offer identifiers at any subscription-level
     I've never worked with Eurekahedge, so I know very little about it.

#The function of the program is to import two Hedge Fund Databases from WRDS (one of which identifying the funds)
#The method I used is to find compare each member of the Morningstar CISDM Hedge Fund Database with each member of Thomson TASS. TASS anonymizes their hedge fund data while Morningstar does not. While I've played with several methods of associating these databases, I find that the one posted has helped me the most.

#While I do have files identifying both Thomson TASS and HFR Hedge Fund Research Databases by their assigned numbers, this is the best I can provide without violating Intellectual Property Laws.
