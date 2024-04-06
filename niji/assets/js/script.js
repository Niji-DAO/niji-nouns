 //Q&A
$(function(){
  $(".vote_detail h3, .faq_category h3").on("click", function() {
    $(this).next().slideToggle();
    $(this).toggleClass('on');
  });
});

//Menu
$(function() {
  $('h1').click(function() {
     if($('h1').hasClass('active')){
       $('h1').removeClass('active');
     } else {
       $('h1').addClass('active');
     }
   });
 });
 $(function () {
     var $body = $('body');
     //開閉用ボタンをクリックでクラスの切替え
     $('h1').on('click', function () {
         $body.toggleClass('open');
     });
     //メニュー名以外の部分をクリックで閉じる
     $('#js__nav, .menuInner li a').on('click', function () {
         $body.removeClass('open');
         $('h1').removeClass('active');
     });
 });