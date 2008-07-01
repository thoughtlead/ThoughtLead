module CoursesHelper
  
  def display_lesson(lesson)
    !lesson.draft || current_user == lesson.chapter.course.community.owner
  end
  
  def lesson_notes(lesson)
    s = ""
    if lesson.premium
      s += "Premium "
    end
    if lesson.registered
      s += "Registered "
    end
    if lesson.draft
      s += "Draft "
    end
    return s
  end
  
  def link_to_lesson(lesson)
    if(lesson.accessible_to(current_user))
      return link_to(h(lesson), [lesson.chapter.course, lesson.chapter, lesson])
    else
      return h(lesson)
    end
  end
end