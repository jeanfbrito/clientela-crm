module TagsHelper
  def most_used_tags
    result = ["Cliente", "Fornecedor", "Prospect", "Lead", "Aluno", "Tutor", "Vip", "Rio de Janeiro"]
    result.insert(0,Contact.tag_counts_on(:tags).map(&:name)).flatten!
    result[0,8]
  end
end
