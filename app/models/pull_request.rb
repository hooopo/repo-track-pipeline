class PullRequest < ApplicationRecord
  belongs_to :repo
  belongs_to :user, optional: true
end
