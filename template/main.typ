#import "@local/basic-resume-bee1850:0.1.0": *
#import("./data/general.typ"): personal-info
#import("./data/work.typ"): work
#import("./data/education.typ"): education
#import("./data/certificates.typ"): certificates
#import("./data/activities.typ"): activities
#import("./data/further_skills.typ"): further_skills


#set text(lang: "en")


#show: resume.with(
  author: personal-info.name,
  author-title: personal-info.author-title, // Optional, if you want to show your title
  // All the lines below are optional.
  // For example, if you want to to hide your phone number:
  // feel free to comment those lines out and they will not show.
  location: personal-info.location,
  email: personal-info.email,
  github: personal-info.github,
  linkedin: personal-info.linkedin,
  phone: personal-info.phone,
  keywords: personal-info.keywords,
  personal-site: personal-info.personal-site, 
  accent-color: "#26428b",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
  education: education,
  work_experience: work,
  extracurricular_act: activities,
  certificates: certificates,
  further_skills: further_skills,
)