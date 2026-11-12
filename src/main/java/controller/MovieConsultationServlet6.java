package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MovieDAO6;
import dao.ShowtimeDAO6;
import model.Movie6;
import model.Showtime6;

@WebServlet("/movie-consultation")
public class MovieConsultationServlet6 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MovieDAO6 movieDAO;
    private ShowtimeDAO6 showtimeDAO;

    @Override
    public void init() {
        movieDAO = new MovieDAO6();
        showtimeDAO = new ShowtimeDAO6();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect("staff-login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "search":
                searchMovies(request, response);
                break;
            case "selectMovie":
                showShowtimes(request, response);
                break;
            case "list":
            default:
                showNowShowing(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void showNowShowing(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Dọn dẹp session đơn hàng cũ để sẵn sàng bán lượt vé mới hoàn toàn sạch sẽ
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("lastInvoiceId");
            session.removeAttribute("completedInvoice");
            session.removeAttribute("completedTickets");
            session.removeAttribute("cashGiven");
            session.removeAttribute("cashChange");
            session.removeAttribute("heldSeats");
            session.removeAttribute("tempTotal");
            session.removeAttribute("discountAmount");
            session.removeAttribute("finalTotal");
            session.removeAttribute("customerMember");
        }

        List<Movie6> allMovies = movieDAO.getNowShowing();
        paginateAndForward(request, response, allMovies, null, null);
    }

    private void searchMovies(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("inKeyword");
        String genre = request.getParameter("inGenre");

        List<Movie6> allMovies = movieDAO.search(keyword, genre);
        paginateAndForward(request, response, allMovies, keyword, genre);
    }

    private void paginateAndForward(HttpServletRequest request, HttpServletResponse response, 
            List<Movie6> allMovies, String keyword, String genre) 
            throws ServletException, IOException {
        int pageSize = 6;
        int totalItems = (allMovies != null) ? allMovies.size() : 0;
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages == 0) totalPages = 1;

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr.trim());
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<Movie6> pagedMovies = (fromIndex < totalItems && allMovies != null) 
                ? allMovies.subList(fromIndex, toIndex) 
                : java.util.Collections.emptyList();

        request.setAttribute("outMovieList", pagedMovies);
        request.setAttribute("outGenreList", movieDAO.getAllGenres());
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("fromItem", totalItems > 0 ? (fromIndex + 1) : 0);
        request.setAttribute("toItem", toIndex);
        request.setAttribute("inKeyword", keyword != null ? keyword : "");
        request.setAttribute("inGenre", genre != null ? genre : "");

        RequestDispatcher dispatcher = request.getRequestDispatcher("MovieConsultationUI6.jsp");
        dispatcher.forward(request, response);
    }

    private void showShowtimes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int movieId = Integer.parseInt(request.getParameter("movieId"));
        Movie6 movie = movieDAO.getById(movieId);
        List<Showtime6> showtimes = showtimeDAO.getByMovie(movieId);

        HttpSession session = request.getSession();
        session.setAttribute("selectedMovie", movie);

        request.setAttribute("movie", movie);
        request.setAttribute("outShowtimeList", showtimes);

        RequestDispatcher dispatcher = request.getRequestDispatcher("ShowtimeSelectionUI6.jsp");
        dispatcher.forward(request, response);
    }
}
