<?php

use App\Engine\EngineFactory;
use App\Engine\FairyVote;
use App\Engine\WolfVote;

use function PHPUnit\Framework\assertTrue;

test('can make engine', function (array $chain) {
    $handler = (new EngineFactory($chain))->make();
    assertTrue($handler instanceof $chain[0]);
})->with([
    [
        [
            WolfVote::class,
            FairyVote::class
        ],
        [
            FairyVote::class
        ],
        [
            WolfVote::class
        ]
    ]
]);
