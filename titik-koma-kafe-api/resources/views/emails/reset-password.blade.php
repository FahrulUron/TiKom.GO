<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset</title>
</head>

<body>
    <h1>Halo, {{ $user->name }}</h1>
    <p>Password Anda telah direset.</p>
    <p>Berikut adalah password baru Anda:</p>
    <h2>{{ $password }}</h2>
    <p>Silakan login menggunakan password ini dan ubah password Anda jika perlu.</p>
    <p>Terima kasih,</p>
    <p>Tim {{ config('app.name') }}</p>
</body>

</html>
