<?php

use App\Http\Controllers\ApiContoller;
use Illuminate\Support\Facades\Route;

Route::controller(ApiContoller::class)->group(function () {
    Route::get('/ping/{token}', 'ping');
});
