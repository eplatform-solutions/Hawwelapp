import { Routes, Route } from "react-router-dom";
import Layout from "./components/Layout";
import Home from "./pages/Home";
import HowItWorks from "./pages/HowItWorks";
import AvailableRegions from "./pages/AvailableRegions";
import Support from "./pages/Support";
import Contact from "./pages/Contact";
import Legal from "./pages/Legal";
import AmlKyc from "./pages/AmlKyc";
import Terms from "./pages/Terms";
import Privacy from "./pages/Privacy";
import DeleteAccount from "./pages/DeleteAccount";
import Learn from "./pages/Learn";
import LearnArticle from "./pages/LearnArticle";
import NotFound from "./pages/NotFound";

export default function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<Home />} />
        <Route path="/how-it-works" element={<HowItWorks />} />
        <Route path="/available-regions" element={<AvailableRegions />} />
        <Route path="/support" element={<Support />} />
        <Route path="/contact" element={<Contact />} />
        <Route path="/legal" element={<Legal />} />
        <Route path="/aml-kyc" element={<AmlKyc />} />
        <Route path="/terms" element={<Terms />} />
        <Route path="/privacy" element={<Privacy />} />
        <Route path="/delete-account" element={<DeleteAccount />} />
        <Route path="/learn" element={<Learn />} />
        <Route path="/learn/:slug" element={<LearnArticle />} />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  );
}
