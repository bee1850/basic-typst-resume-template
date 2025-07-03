#import "@local/basic-resume-bee1850:0.1.0": dates-helper
#let education = (
    (
      institution: "...",
      location: "...",
      dates: dates-helper(datetime(day: 1, month:8, year: 2022), datetime.today()),
      degree: "Bachelors of Science, Cybersecurity",
      grade: "...",
      description: [
       - Test
      ],
      learned_skills: ( 
        "Technologies": 
          ("Docker", "Git", "Python", "Bash", "C/C++", "SQL", "Excel", "Word", "Powerpoint"),
        "Management": 
          ("Risk Management", "Quality Management", "Project Management"), 
        "Operating Systems": 
          ("Windows", "BSD (FreeBSD, OpenBSD)", "Debian-based Linux")
      )
    ),
)