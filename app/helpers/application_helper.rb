# frozen_string_literal: true

module ApplicationHelper
  # 表格树
  def draw_tree(partial:, object:, **options)
    concat(render(partial: partial, object: object, **options))

    object.children.each { |child| draw_tree(partial: partial, object: child, **options) if child.children.any? }
  end
end
