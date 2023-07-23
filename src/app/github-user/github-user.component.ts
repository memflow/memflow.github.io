import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-github-user',
  templateUrl: './github-user.component.html',
  styleUrls: ['./github-user.component.sass']
})
export class GithubUserComponent implements OnInit {

  @Input() userName: string;
  @Input() profilePicture: string;

  constructor() { }

  ngOnInit(): void {
  }

}
