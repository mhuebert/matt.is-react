ownerId = "15538074"

ownerOrNew = "auth != null && (!data.exists() || data.child('owner').val() == auth.id)"
userOwnsObject = "newData.child('owner').val() == auth.id"

module.exports =

  settings:
    write: "(data.child('ownerId').val() == null || data.child('ownerId').val() == auth.id)"
    read: true
  themes:
    read: true
    write: true
  people:
    read: true
    write: true
  tags:
    read: true
    users:
      $user:
        write: "$user == auth.id"
        $tag:
          $post:
            validate: "root.child('posts').hasChild($post)"
    $tag:
      $post:
        validate: "root.child('posts/'+$post).hasChild($tag)"
        write: ownerOrNew

  # users are private
  users:
    $user:
      write: "$user == auth.id"
      read: "$user == auth.id"
      ideas:
        $post:
          validate: "root.child('posts').child($post).child('owner').val() == auth.id"
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