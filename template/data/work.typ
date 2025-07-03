#import "@local/basic-resume-bee1850:0.1.0": dates-helper
#let work = (
    (
      title: "",
      location: "",
      company: ("COMPANY NAME", "formerly ..."),
      dates: dates-helper(datetime(day: 1, month:8, year: 2022), datetime.today()), // end date today means its ongoing
      description: [
        - Worked as a DevOps Engineer on multiple in-house projects including topics around ...
      ],
      learned_skills: ("Technologies": ("Docker", "VIM", "Git"), "Programming/Scripting Languages": ("Python", "Bash", "...", "JavaScript"), "Operating Systems": ("..."))
    ),
)