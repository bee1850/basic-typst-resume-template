#import "@preview/scienceicons:0.1.0": cc-by-icon, email-icon, github-icon, linkedin-icon, website-icon, orcid-icon
#let skills_state = state("skills", (:)) // Initialize skills as an empty list

#let language_dict = (
  "en": (
    "fing": "Final Grade",
    "educ": "Education",
    "work": "Work Experience",
    "extr": "Extracurricular Activities",
    "proj": "Projects",
    "cert": "Certificates",
    "skil": "Skills",
    "fski": "Further Skills",
  ),
  "de": (
    "fing": "Abschlussnote",
    "educ": "Bildung",
    "work": "Berufserfahrung",
    "extr": "Außerschulische Aktivitäten",
    "proj": "Projekte",
    "cert": "Zertifikate",
    "skil": "Fähigkeiten",
    "fski": "Weitere Fähigkeiten",
  ),
)

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

#let equals(string, comp) = {
  // Check if the string is equal to the comparison value
  if (string == comp) {
    // If they are equal, return true
    true
  } else {
    // If not, return false
    false
  }
}

#let parse-date(string) = {
  // Define month names mapping to month numbers (zero-based)
  let months = (
    "Jan": 0, "Feb": 1, "Mar": 2, "Apr": 3, "May": 4, "Jun": 5,
    "Jul": 6, "Aug": 7, "Sep": 8, "Oct": 8, "Nov": 10, "Dec": 11
  )

  // Split input string into parts
  let parts = string.split(" ")

  // Extract month and year
  let month-str = parts.at(0)
  let year = int(parts.at(1))

  // Look up month number from mapping
  let month = months.at(month-str) +1 // default to 0 if not found
  
  // Return datetime with day = 1
  datetime(year: year, month: month, day: 1)
}

#let generic-two-by-two-with-description(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
  description: (),
) = {
  context[
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
    #description.at(text.lang)
  ]
}

// Generic one by two component for resume
#let generic-one-by-two-with-description(
  left: "",
  right: "",
  description: (),
) = {
  context[
    #left #h(1fr) #right
    #description.at(text.lang)
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature becuase ligatures are disabled for good reasons
#let dates-helper(
  start-date,
  end-date,
) = {

  let start = if (type(start-date) == "str") {
    parse-date(start-date)
  } else {
    start-date
  }

  let end = if (type(end-date) == "str") {
    parse-date(end-date)
  } else {
    end-date
  }

  let terms = (
    "en": (
      mnth: "month",
      mnths: "months",
      yrs: "years",
      prsnt: "Present",
    ),
    "de": (
      mnth: "Monat",
      mnths: "Monate",
      yrs: "Jahre",
      prsnt: "Heute",
    ),
  )

  context {
    let distance_exact = (end - start).weeks() / 4.34524
  let distance_month = calc.floor(distance_exact) // Average number of weeks in a month
  let distance = none
  if (distance_month <= 12) {
    if(distance_month == 1) {
      distance = [#calc.round(distance_exact, digits: 1)] + " " + terms.at(text.lang).mnth
    } else {
      distance = [#calc.round(distance_exact, digits: 1)] + " " + terms.at(text.lang).mnths
    }
  } else {
    distance = [#calc.round((distance_exact / 12 ), digits: 1)] + " " + terms.at(text.lang).yrs
  }
  let end-str = ""
  let today = datetime.today()
  if((today - end).days() < 5) {
    end-str = terms.at(text.lang).prsnt
  } else {
    end-str = end.display("[month repr:short] [year]")
  }
  start.display("[month repr:short] [year repr:last_two]") + " " + $dash.em$ + " " + end-str + " [" + [#distance] + "]"
  }

 
}

#let add_skills(dict) = {
  
  
  let topics = dict.keys()
  
  context{

    let skills = skills_state.get()
    for topic in topics {
      let dict_items = dict.at(topic)
        // If the topic already exists, append the new items
        
        
        let existing_items = skills.at(topic, default: ())
        
        existing_items.push(dict_items)
        
        existing_items = existing_items.flatten()

        // merge array
        let new_items = existing_items.dedup()
       
        skills.insert(topic, new_items)
        
        
    }
    skills_state.update(skills)  
    
  }
  
}

// Section components below
#let edu(
  institution: "",
  dates: "",
  degree: "",
  grade: "",
  location: "",
  description: (),
  learned_skills: ()
) = {
 
  context {
    
 if(description != "") {
    generic-two-by-two-with-description(
      top-left: strong(institution),
      top-right: dates,
      bottom-left: emph(degree + " | " + [#language_dict.at(text.lang).fing] + ": "+ grade),
      bottom-right: emph(location),
      description: description,
    )
  } else {
    generic-two-by-two(
      top-left: strong(institution),
      top-right: dates,
      bottom-left: emph(degree),
      bottom-right: emph(location),
    )
  }

  add_skills(learned_skills)
  }
}

#let work(
  title: "",
  dates: "",
  company: (),
  location: "",
  description: (),
  learned_skills: ()
) = {
  let main_company = company.at(0)
  let company_extra = company.slice(1, company.len())

  company = [#emph(main_company), #text(9pt, company_extra.join(", "))]
  

  if(description != "") {
    generic-two-by-two-with-description(
      top-left: strong(title),
      top-right: dates,
      bottom-left: company,
      bottom-right: location,
      description: description,
    )
  } else {
    generic-two-by-two(
      top-left: strong(title),
      top-right: dates,
      bottom-left: company,
      bottom-right: location,
    )
  }

  add_skills(learned_skills)
}

#let project(
  role: "",
  name: "",
  url: "",
  dates: "",
  learned_skills: ()
) = {

  generic-one-by-two(
    left: {
      if role == "" {
        [*#name* #if url != "" and dates != "" [ (#link("https://" + url)[#url])]]
      } else {
        [*#role*, #name #if url != "" and dates != ""  [ (#link("https://" + url)[#url])]]
      }
    },
    right: {
      if dates == "" and url != "" {
        link("https://" + url)[#url]
      } else {
        dates
      }
    },
  )
  

  add_skills(learned_skills)
}

#let certificate(
  name: "",
  issuer: "",
  url: "",
  date: datetime,
  until: "",
  learned_skills: ()
) = {

  [
    *#name*, #issuer
    #if url != "" {
      [ (#link("https://" + url)[#url])]
    }
    #h(1fr) #date.display("[month repr:short] [year]")#if((until != "Never" and until != "") and date != none) {
      [, Expires: #until]
    }
  ]
  

  add_skills(learned_skills)
}

#let extracurriculars(
  activity: "",
  dates: "",
  learned_skills: (),
  description: (),
) = {
  if(description != "") {
    generic-one-by-two-with-description(
      left: strong(activity),
      right: dates,
      description: description
    )
  } else {
    generic-one-by-two(
      left: strong(activity),
      right: dates
    )
  }
  add_skills(learned_skills)
}

#let render-skills() ={
  context{
  let skills = skills_state.get()

    if(skills != none and skills != () and skills != "" and skills != "none") {
    let topics = skills.keys()
    topics = topics.sorted() // Sort topics alphabetically
    for topic in topics {
      if(topic != "PLACEHOLDER") [
        #let skills_items = skills.at(topic)
        - *#topic:* #skills_items.join(", ") \
      ] 
    }
  }
  }
}

#let resume(
  author: "",
  author-title: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  keywords: (),
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  body,

  // Sections
  work_experience: (),
  education: (),
  projects: (),
  certificates: (),
  extracurricular_act: (),
  further_skills: (),
) = {
 context {
  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    margin: (0.5in),
    paper: paper,
  )

  // Link styles
  show link: underline


  // Small caps for section titles
  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #if(author-title.pre != "") {
    [#author-title.pre]
  } #(author) #if(author-title.post != "") {
    [(#author-title.post)]
  }]

  // Personal Info Helper
  let contact-item(value, prefix: "", link-type: "") = {
    if value != "" {
      if link-type != "" {
        link(link-type + value)[#(prefix + value)]
      } else {
        if(prefix != "") {
          [#(prefix + value)]
        } else {
          [#(value)]
        }
      }
    }
  }

  // Personal Info
  pad(
    top: 0.25em,
    align(personal-info-position)[
      #{
        let items = (
          contact-item(pronouns),
          contact-item(phone),
          contact-item(location),
          contact-item(email, prefix: [#email-icon(color: rgb("#353632")) ],  link-type: "mailto:"),
          contact-item(github, prefix: [#github-icon(color: rgb("#191b10")) ],  link-type: "https://"),
          contact-item(linkedin, prefix: [#linkedin-icon(color: rgb("#0A66C2")) ],  link-type: "https://"),
          contact-item(personal-site, prefix: [#website-icon(color: rgb("#9c5098")) ],  link-type: "https://"),
          contact-item(orcid, prefix: [#orcid-icon(color: rgb("#AECD54")) ], link-type: "https://orcid.org/"),
        )
        items.filter(x => x != none).join("  |  ")
      }
      #if(keywords != () and keywords != none and keywords != "") {
        [\ #par(justify: true, keywords.join(", "))]
      }
    ]
  )

  // Main body.
  set par(justify: true)

  if(education.len() > 0) {
    [== #language_dict.at(text.lang).educ]

    for education_entry in education {
      edu(..education_entry)
    }
  }
  

  
  if(work_experience.len() > 0) {
    [#v(1fr)]
    [== #language_dict.at(text.lang).work]

    for work_entry in work_experience {
      work(..work_entry)
    }
  }

  
  if(extracurricular_act.len() > 0) {
    [#v(1fr)]
    [== #language_dict.at(text.lang).extr]
    
    for activity in extracurricular_act {
      extracurriculars(..activity)
    }
  }
  
  
  if(projects.len() > 0) {
    [#v(1fr)]
    [== #language_dict.at(text.lang).proj]
    for project_entry in projects {
    project(
      name: project_entry.name,
      role: project_entry.role,
      dates: project_entry.dates,
      url: project_entry.url
    )
  }
  }
  

 
  if(certificates.len() > 0)  {
    [#v(1fr)]
    [== #language_dict.at(text.lang).cert]
    for cert_entry in certificates {
      certificate(..cert_entry)
    }
  }
  
  [#v(1fr)]
  [== #language_dict.at(text.lang).skil]
  render-skills()


  if(further_skills.len() > 0)  {
    [#v(1fr)]
    [== #language_dict.at(text.lang).fski]
    for (key, value) in further_skills {
      [
        - *#key:* #value.join(", ") \
      ] 
    }
  }
  }
}

