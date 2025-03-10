<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Unit tests for the relativedate condition.
 *
 * @package   availability_relativedate
 * @copyright 2022 eWallah.net
 * @author    Renaat Debleu <info@eWallah.net>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
namespace availability_relativedate;

use availability_relativedate\condition;

/**
 * Unit tests for the relativedate condition.
 *
 * @package   availability_relativedate
 * @copyright 2022 eWallah.net
 * @author    Renaat Debleu <info@eWallah.net>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 * @coversDefaultClass \availability_relativedate\condition
 */
class simple_test extends \advanced_testcase {

    /**
     * Tests the constructor including error conditions.
     * @covers \availability_relativedate\condition
     */
    public function test_constructor() {
        $structure = (object)['type' => 'relativedate'];
        $cond = new condition($structure);
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
        $structure->n = 1;
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
        $cond = new condition($structure);
        $structure->d = 1;
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
        $cond = new condition($structure);
        $structure->d = '2';
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
        $cond = new condition($structure);
        $structure->n = 'a';
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
        $cond = new condition($structure);
        $structure->e = 'a';
        $cond = new condition($structure);
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
        $structure->c = 'a';
        $cond = new condition($structure);
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
        $structure->n = 9;
        $structure->c = 1111;
        $cond = new condition($structure);
        $this->assertNotEqualsCanonicalizing($structure, $cond->save());
    }

    /**
     * Tests the save() function.
     * @covers \availability_relativedate\condition
     */
    public function test_save() {
        $structure = (object)['n' => 1, 'd' => 2, 's' => 1, 'm' => 1];
        $cond = new condition($structure);
        $structure->type = 'relativedate';
        $this->assertEquals($structure, $cond->save());
    }

    /**
     * Tests static methods.
     * @covers \availability_relativedate\condition
     */
    public function test_static() {
        $this->assertCount(5, condition::options_dwm());
        $this->assertEquals('minute', condition::option_dwm(0));
        $this->assertEquals('hour', condition::option_dwm(1));
        $this->assertEquals('day', condition::option_dwm(2));
        $this->assertEquals('week', condition::option_dwm(3));
        $this->assertEquals('month', condition::option_dwm(4));
        $this->assertEquals('', condition::option_dwm(5));
        $this->assertEquals('after course start date', condition::options_start(1));
        $this->assertEquals('before course end date', condition::options_start(2));
        $this->assertEquals('after user enrolment date', condition::options_start(3));
        $this->assertEquals('after enrolment method end date', condition::options_start(4));
        $this->assertEquals('after course end date', condition::options_start(5));
        $this->assertEquals('before course start date', condition::options_start(6));
        $this->assertEquals('after completion of activity', condition::options_start(7));
        $this->assertEquals('', condition::options_start(8));
    }
}
