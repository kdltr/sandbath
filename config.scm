(database-file "./tracker.db")
(accounts-file "./accounts.db")
(score-types
 '(("type"
    ("Documentation: A documentation issue."
     "Localization: A translation issue."
     "Visual and Sound Polish: Aesthetic issues."
     "Balancing: Enables degenerate usage strategies that harm the experience."
     "Minor usability: Impairs usability in secondary scenarios."
     "Major usability: Impairs usability in key scenarios."
     "Crash: Bug causes crash or data loss. Asserts in the Debug release."))
   ("priority"
    ("Nuisance – not a big deal but noticeable. Extremely unlikely to affect sales."
     "A Pain – users won’t like this once they notice it. A moderate number of users won’t buy."
     "A User would likely not purchase the product. Will show up in review. Clearly a noticeable issue."
     "A User would return the product. Cannot RTM. The Team would hold the release for this bug."
     "Blocking further progress on the daily build."))
   ("likelihood"
    ("Will affect almost no one."
     "Will only affect a few users."
     "Will affect average number of users."
     "Will affect most users."
     "Will affect all users."))))
