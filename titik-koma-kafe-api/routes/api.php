<?php

use App\Http\Controllers\Api\JenisMenuController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\OrderMenuController;
use App\Http\Controllers\Api\OrderMenuDetailController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::resource("/user", UserController::class);
Route::resource("/menu", MenuController::class);
Route::resource("/jenis-menu", JenisMenuController::class);
Route::resource("/order-menu", OrderMenuController::class);
Route::resource("/order-menu-detail", OrderMenuDetailController::class);

Route::post('/login', [UserController::class, 'login']);
Route::post('/reset-password', [UserController::class, 'resetPassword']);
Route::post("/pesan", [OrderMenuController::class, 'pesan']);
Route::post("/selesaikan-pesanan", [OrderMenuController::class, 'selesaikanPesanan']);
