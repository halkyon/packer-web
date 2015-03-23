<?php
class GeneratePagesTask extends BuildTask {

	public function run($request) {
		for($i = 1; $i < 5; $i++) {
			$segment = sprintf('page-top-level-%d', $i);
			$p1 = SiteTree::get_by_link($segment);
			if(!($p1 && $p1->exists())) {
				echo "Creating page $i...";

				$p1 = new Page();
				$p1->Title = 'Page Top Level ' . $i;
				$p1->Content = 'This is the content for the page';
				$p1->URLSegment = $segment;
				$p1->write();
				$p1->publish('Stage', 'Live');

				echo "Done (ID $p1->ID)\n";
			}

			for($j = 1; $j < 5; $j++) {
				$segment = sprintf('page-second-level-%d-%d', $i, $j);
				$p2 = SiteTree::get_by_link($segment);
				if(!($p2 && $p2->exists())) {
					echo "Creating page $j (parent $i)...";

					$p2 = new Page();
					$p2->Title = 'Page Second Level ' . $j;
					$p2->Content = 'This is the content for the page';
					$p2->URLSegment = $segment;
					$p2->ParentID = $p1->ID;
					$p2->write();
					$p2->publish('Stage', 'Live');

					echo "Done (ID $p2->ID)\n";
				}

				for($k = 1; $k < 5; $k++) {
					$segment = sprintf('page-third-level-%d-%d-%d', $i, $j, $k);
					$p3 = SiteTree::get_by_link($segment);
					if(!($p3 && $p3->exists())) {
						echo "Creating page $k (parent $j, parent $i)...";

						$p3 = new Page();
						$p3->Title = 'Page Third Level ' . $k;
						$p3->Content = 'This is the content for the page';
						$p3->URLSegment = $segment;
						$p3->ParentID = $p2->ID;
						$p3->write();
						$p3->publish('Stage', 'Live');

						echo "Done (ID $p3->ID)\n";
					}

					for($l = 1; $l < 5; $l++) {
						$segment = sprintf('page-fourth-level-%d-%d-%d-%d', $i, $j, $k, $l);
						$p4 = SiteTree::get_by_link($segment);
						if(!($p4 && $p4->exists())) {
							echo "Creating page $l (parent $k, parent $j, parent $i)...";

							$p4 = new Page();
							$p4->Title = 'Page Fourth Level ' . $l;
							$p4->Content = 'This is the content for the page';
							$p4->URLSegment = $segment;
							$p4->ParentID = $p3->ID;
							$p4->write();
							$p4->publish('Stage', 'Live');

							echo "Done (ID $p4->ID)\n";
						}
					}
				}
			}
		}
	}

}
