<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JenisMenu extends Model
{
    /** @use HasFactory<\Database\Factories\JenisMenuFactory> */
    use HasFactory;

    protected $fillable = [
        'nama_jenis',
        // 'title',
        // 'content',
    ];
}
