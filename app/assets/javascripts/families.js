function lg(s) { console.log(s); }

$(function() {
    fam.init();
});

fam = {
    init: function() {
        var $scope = $('.fam_family');
        this.scorePercents.init($scope.find('.fam_scorePercents'));
        this.studentsRanking.init($scope.find('.fam_students'), 20);
        this.teamRanking.init($scope.find('.fam_teamRanking'), [
            'baratheons',
            'lannisters',
            'starks',
            'targaryens'
        ]);
        this.stats.init($scope.find('.fam_advices'), 5);
        this.jq_divTeamScore = $scope.find('.fam_teamScore');
        this.el_imgLogo = $scope.find('.fam_teamScore img')[0];
        this.el_spanScore = $scope.find('.fam_teamScore span')[0];
        this.rssBonus = new this.listNews($scope.find('.fam_listNews.fam_bonus'));
        this.rssMalus = new this.listNews($scope.find('.fam_listNews.fam_malus'));
        this.ajax();
    },
    ajax: function() {
        var self = this,
            q = {
                type: 'GET',
                dataType: 'json'
            },
            url = window.location.href,
        // url = 'http://cortex.epitech.eu:3000/families/3',
            URLs = [
                    url.substr(0, url.lastIndexOf('/')) + '.json',
                    url + '.json'
            ],
            URL_ind = 0,
            fn_changeTarget = function() {
                q.url = URLs[URL_ind = 1 * !URL_ind];
            },
            fn_update = function() {
                $.ajax(q)
                    .done(function(data) {
                        lg(data)
                        self.setData(data);
                    });
            };
        fn_changeTarget();
        fn_update();
        setInterval(fn_changeTarget, 1000 * 10);
        setInterval(fn_update,       1000 *  5);
    },
    setData: function(data) {
        data.team_ranking.total = 0;
        $.each(data.team_ranking, function(k, v) {
            if (v > data.team_ranking.total)
                data.team_ranking.total = v;
        });
        this.setFamily(data.name);
        this.setScore(
                data.score.methodology_score +
                data.score.organization_score +
                data.score.technical_score
        );
        this.scorePercents.update(data.score);
        this.teamRanking.update(data.team_ranking);
        this.rssBonus.empty();
        this.rssBonus.addNews(data.positive_point);
        this.rssMalus.empty();
        this.rssMalus.addNews(data.negative_point);
        this.studentsRanking.update(data.best_members);
        this.stats.update(data.stat_details);
    },
    setFamily: function(fam) {
        this.setLogo(fam);
        this.teamRanking.select(fam);
        if (fam)
            this.showScore();
        else
            this.hideScore();
    },
    setLogo: function(fam) { this.el_imgLogo.src = '/assets/family_logo/m-' + (fam ? fam : 'all') + '.png'; },
    setScore: function(score) { this.el_spanScore.textContent = score; },
    showScore: function() { this.jq_divTeamScore.removeClass('fam_noScore'); },
    hideScore: function() { this.jq_divTeamScore.addClass('fam_noScore'); }
};

fam.stats = {
    init: function($scope, nbRows) {
        var $tbody = $scope.find('tbody');
        this.rows = [];
        for (var i = 0; i < nbRows; ++i) {
            var $row = $(
                    '<tr class="">'+
                    '<td></td>'+
                    '<td></td>'+
                    '<td></td>'+
                    '</tr>'
            ).appendTo($tbody);
            this.rows.push($row.add('td', $row));
            this.rows[i][0] = $row;
        }
    },
    update: function(data) {
        var self = this,
            row, i = 0;
        $.each(data, function(key, val) {
            var row = self.rows[i++];
            row[0].addClass(val.bonus ? 'fam_bonus' : 'fam_malus');
            row[1].textContent = key.replace(/_/g, ' ');
            row[2].textContent = val.daily;
            row[3].textContent = val.all;
        });
    }
};

fam.listNews = function($scope) {
    this.$list = $scope.find('.fam_list');
}
fam.listNews.prototype = {
    empty: function() {
        this.$list.empty();
    },
    addNews: function(news) {
        var self = this;
        $.each(news, function() {
            self.$list.append(
                    '<div class="fam_table">'+
                    '<div class="fam_logo">'+
                    '<img src="/assets/family_logo/s-'+this.family+'.png"/>'+
                    '</div>'+
                    '<div class="fam_statusContainer">'+
                    '<span class="fam_pts fam_borderRadius">'+
                    this.score+
                    '<span class="fam_puce fam_bg_'+this.category+'"></span>'+
                    '</span>'+
                    '<div class="fam_status">'+this.title+'</div>'+
                    '</div>'+
                    '<div class="fam_msg">'+
                    '<span class="fam_login">'+this.login+'</span> '+
                    this.description+
                    '</div>'+
                    '</div>'
            );
        });
    }
};

fam.teamRanking = {
    init: function($scope, teams) {
        var self = this,
            teamsElem = [],
            $frieze = $scope.find('.fam_frieze');
        this.teams = {};
        $.each(teams, function() {
            var $el = $(
                    '<div class="fam_team fam_bg_'+this+'">'+
                    '<div class="fam_borderRadius">'+
                    '<img src="/assets/family_logo/s-'+this+'.png"/><br/>'+
                    '<span>0%</span>'+
                    '</div>'+
                    '</div>'
            );
            self.teams[this] = $el;
            teamsElem.push($el[0]);
        });
        this.$teams = $(teamsElem).appendTo($frieze);
        this.$span = this.$teams.find('span');
        this.$teams.find('div').css('top', function(i) {
            return (i / teams.length * 100) + '%';
        });
    },
    select: function(team) {
        if (team)
            this.$teamSelected = this.teams[team].addClass('fam_select');
        else if (this.$teamSelected)
            this.$teamSelected.removeClass('fam_select');
    },
    update: function(score) {
        var total = score.total ? score.total : 1,
            arr = [
                score.baratheons,
                score.lannisters,
                score.starks,
                score.targaryens
            ];
        this.$teams.css('left', function(i) { return arr[i] / total * 100 + '%'; });
        this.$span.text(function(i) { return parseInt(arr[i]); });
    }
};

fam.scorePercents = {
    init: function($scope) {
        this.$percentsColor = $scope.find('.fam_graph > *');
        this.$percentsSpan = $scope.find('.fam_infos .fam_percent');
        this.update([0, 0, 0]);
    },
    update: function(score) {
        var total =
                (score.technical_score < 0 ? 0 : score.technical_score) +
                (score.organization_score < 0 ? 0 : score.organization_score) +
                (score.methodology_score < 0 ? 0 : score.methodology_score),
            arr = (total === 0)
                ? [33.3, 33.3, 33.4]
                : [
                    parseInt(score.technical_score    / total * 1000) / 10,
                    parseInt(score.organization_score / total * 1000) / 10,
                    parseInt(score.methodology_score  / total * 1000) / 10
            ];
        this.$percentsColor.css('width', function(i) { return arr[i] + '%'; });
        this.$percentsSpan.text(function(i) { return parseInt(arr[i]); });
    }
};


fam.studentsRanking = {
    init: function($scope, nbStudents, categories) {
        var self = this;
        this.rank = [];
        this.nbStudents = nbStudents;
        $scope.find('.fam_ranking').each(function() {
            var stu = [];
            for (var i = 0; i < nbStudents; ++i) {
                var $l = $(
                        '<div>'+
                        '<span class="fam_rank"></span>'+
                        '<div><img src=""/></div>'+
                        '<span class="fam_login"></span>'+
                        '<span class="fam_score"></span>'+
                        '</div>'
                ).appendTo(this);
                stu.push({
                    rank    : $l.find('.fam_rank')[0],
                    imgTeam : $l.find('img')[0],
                    login   : $l.find('.fam_login')[0],
                    score   : $l.find('.fam_score')[0]
                });
            }
            self.rank[this.getAttribute('category')] = stu;
        });
    },
    update: function(rankings) {
        var self = this,
            j = 0;
        $.each(rankings, function(category, array) {
            $.each(array, function(i) {
                var line = self.rank[category][i];
                line.rank.textContent = i + 1;
                line.imgTeam.src = '/assets/family_logo/s-' + this.family + '.png';
                line.login.textContent = this.login;
                line.score.textContent = this.score;
                j = i + 1;
            });
            for (var i = j; i < self.nbStudents; ++i) {
                var line = self.rank[category][i];
                line.rank.textContent =
                    line.imgTeam.src =
                        line.login.textContent =
                            line.score.textContent = '';
            }
        })
    }
};
