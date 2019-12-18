module Quotable

def quotes
  [
    "you shouldn't have come back #{current_user.username}",
    "here's looking at you #{current_user.username}",
    "heeeere's #{current_user.username}",
    "hello, my name is #{current_user.username}. you killed my father, prepare to die","#{current_user.username} knows kung-fu",
    "yipee kayaye #{current_user.username}", "#{current_user.username} don't text","#{current_user.username}, i am your father", "#{current_user.username} i have a feeling we're not in kansas anymore", "soylent green is #{current_user.username}", "frankly #{current_user.username}, i don't give a damn","i'll have what #{current_user.username}'s having","forget it #{current_user.username} it's chinatown"
  ]
end
end
