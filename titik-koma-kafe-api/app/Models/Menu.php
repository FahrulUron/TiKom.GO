<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    /** @use HasFactory<\Database\Factories\MenuFactory> */
    use HasFactory;
    protected $fillable = [
        'nama',
        'jenis_id',
        'harga',
        'foto'
        // 'content',
    ];

    public function jenis()
    {
        return $this->belongsTo(JenisMenu::class, 'jenis_id', 'id');
    }
}
