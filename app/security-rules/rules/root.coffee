ownerId = "15538074"

isAdmin = "auth.id == '#{ownerId}'"
ownerOrNew = "auth != null && (!data.exists() || data.child('owner').val() == auth.id)"
userOwnsObject = "newData.child('owner').val() == auth.id"

module.exports =

  settings:
    write: "(data.child('ownerId').val() == null || data.child('ownerId').val() == auth.id)"
    read: true
  topics:
    read: true
    write: isAdmin
  people:
    read: true
    write: isAdmin
  elements:
    read: true
    write: isAdmin
  types:
    read: true
    write: isAdmin
  related:
    read: true
    write: isAdmin
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
      write: isAdmin

  posts:
    $post:
      read: "data.child('public').val() == true || data.child('owner').val() == auth.id"
      write: isAdmin
      validate: userOwnsObject
      permalink:
        validate: "root.child('permalinks').child(newData.val()).exists()"

  permalinks:
    read: true
    $link:
      write: isAdmin
      validate: "newData.child('redirect').isString()"