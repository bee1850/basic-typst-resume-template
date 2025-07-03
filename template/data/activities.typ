#import "@local/basic-resume-bee1850:0.1.0": dates-helper
#let activities = (
    (
      activity: "Capture The Flag Competitions",
      dates: dates-helper(datetime(day: 1, month:8, year: 2022), datetime.today()),
      learned_skills: ("Cybersecurity": ("Penetration Testing", "Reverse Engineering", "Web Security", "Cryptography", "Forensics", "Binary Exploitation")),
      description: (
        "en": [
          - ... 2022, 5th Place
          - ... 2023, 1st Place
        ], 
        "de":[
          - ... 2022, 5. Platz
          - ... 2023, 1. Platz
        ]
      )
    ),
)