ownerId = "15538074"

ownerOrNew = "auth != null && (!data.exists() || data.child('owner').val() == auth.id)"
userOwnsObject = "newData.child('owner').val() == auth.id"

module.exports = 

  tags:
    users:
      $user:
        write: "$user == auth.id"
        $tag:
          $post:
            validate: "root.child('posts').hasChild($post)"
    $tag:
      $post:
        validate: "root.child('posts').hasChild($post)"
        write: ownerOrNew

  # users are private
  users:
    $user:
      write: "$user == auth.id"
      read: "$user == auth.id"
      ideas:
        $post:
          validate: "root.child('posts').hasChild($post)"
      writing:
        read: true
        $post:
          validate: "root.child('posts').hasChild($post)"

  # photos are public
  photos:
    read: true
    $photo:
      write: ownerOrNew

  posts:
    $post:
      read: "data.child('public').val() == true || data.child('owner').val() == auth.id"
      write: ownerOrNew
      validate: userOwnsObject
      permalink:
        validate: "root.child('permalinks').child(newData.val()).exists()"

  permalinks:
    read: true
    $link:
      write: ownerOrNew
      validate: "newData.child('redirect').isString()"